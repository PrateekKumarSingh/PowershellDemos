
# This Function add space where required to format Write-host output in a tabular form
Function Add-Space($Length,$Maximum)
{
    $space ="";1..$([int]($Maximum - $Length)+1)|%{$space+=" "};[String]$space
}

# Function to telnet a port from a Source to a Destination 
# Using the .Net class System.Net.Sockets.TCP/UDPClient
Function Invoke-Telnet
{

[Alias("Tn")]
[Cmdletbinding()]
Param(
        [String[]] $Destination, 
        [Int[]] $port, 
        [string[]] $Protocol,
        [Int] $TCPTimeOut=1000,  # 1000 ms default TCP TimeOut
        [Int] $UDPTimeOut=5000,   # 5000 ms default UDP TimeOut
        [Int] $PingTimeout=80,
        [Bool] $Iterate
)

Begin
{
    $Source = (hostname).toupper()    
    $MaxStringLength = $Destination | ForEach-Object { $_.length } | measure -Maximum | ForEach-Object Maximum
    
    # This Function add space where required to format Write-host output in a tabular form
    Function Add-Space($Length,$Maximum)
    {
        $space ="";1..$([int]($Maximum - $Length)+1)|%{$space+=" "};[String]$space
    }

    # Though we have Test-Connection cmdlet, but that doesn't have a Timeout option in it. 
    # Which makes running the script for multiple machines somewhat slower, as it waits for default timeout
    # As a workaround, instantiating System.Net class give us an option to specify the TimeOut for ICMP requests, hence this function
    Function Invoke-QuickPing
    {
        [CmdletBinding()]
        Param(
                [String] $Computername,
                [int] $PingTimeOut = 80
        ) 
        [switch]$resolve = $true
        [int]$TTL = 128
        [switch]$DontFragment = $false
        [int]$buffersize = 32
        $options = new-object system.net.networkinformation.pingoptions
        $options.TTL = $TTL
        $options.DontFragment = $DontFragment
        $buffer=([system.text.encoding]::ASCII).getbytes("hi"*$buffersize)
        $Ping = New-Object system.net.networkinformation.ping
        #$Ping.se
        $Ping.Send($Computername,$PingTimeOut,$buffer,$options)
        $Ping.Dispose()
    }
}
Process
{

    Foreach($Target in $Destination)
    {
        Foreach($CurrentPort in $Port)
        {
            #Write-Verbose "Testing $Protocol port $CurrentPort from $Source to $Target"

            $HostStatus = (Invoke-QuickPing $Target $PingTimeOut -ErrorAction SilentlyContinue).status
            
            If($Protocol -eq 'TCP')
            {

                Try
                {
                    # Instantiate TCPClient Socket
                    $TCPClient = new-Object system.Net.Sockets.TcpClient 

                    # Establish connection to the Port             
                    $Connection = $TCPClient.BeginConnect($Target,$CurrentPort,$null,$null) 

                    # Wait for connection to Timeout
                    $Wait = $Connection.AsyncWaitHandle.WaitOne($TCPTimeOut,$false)
                    #$wait
                    If ($wait)
                    {
                        $TCPClient.EndConnect($Connection) | out-Null
                        If($Iterate)
                        {
                            Write-host "$($Source.toupper()) | $($Target.toupper())$(Add-Space $Target.length $MaxStringLength) |" -NoNewline
                            if($HostStatus -eq 'Success')
                            { 
                                Write-host " HostUp     " -ForegroundColor Green -NoNewline
                            }
                            else
                            {
                                Write-Host " HostDown   " -ForegroundColor Red -NoNewline
                            } 
                            
                            Write-Host "| $Protocol      | " -NoNewline
                            Write-Host "$currentPort" -ForegroundColor Green
                        }
                        else
                        {
                        ''|select @{n='Source';e={$Source}},`
                                  @{n='Destination';e={$Target.toupper()}},`
                                  @{n='Protocol';e={$Protocol}},`
                                  @{n='Port';e={$CurrentPort}},`
                                  @{n='Open';e={$true}}, `
                                  @{n='HostUp?';e={If($HostStatus -eq 'success'){$True}else{$false}}} 
                        }
                    }
                    else
                    {
                        If($Iterate)
                        {
                                Write-host "$((hostname).toupper()) | $($Target.toupper())$(Add-Space $Target.length $MaxStringLength) |" -NoNewline
                                if($HostStatus -eq 'Success')
                                {
                                    Write-host " HostUp     " -ForegroundColor Green -NoNewline
                                }
                                else
                                {
                                    Write-Host " HostDown   " -ForegroundColor Red -NoNewline
                                } 
                                
                                Write-Host "| $Protocol      | " -NoNewline
                                Write-Host "$currentPort" -ForegroundColor Red
                        }
                        else
                        {
                        ''|select @{n='Source';e={$Source}},`
                                  @{n='Destination';e={$Target.toupper()}},`
                                  @{n='Protocol';e={$Protocol}},`
                                  @{n='Port';e={$CurrentPort}},`
                                  @{n='Open';e={$false}}, `
                                  @{n='HostUp?';e={If($HostStatus -eq 'success'){$True}else{$false}}} 
                        }

                    }
                }
                Catch
                {
                    If($Iterate)
                    {
                        Write-host "$((hostname).toupper()) | $($Target.toupper())$(Add-Space $Target.length $MaxStringLength) |" -NoNewline
                        if($HostStatus -eq 'Success')
                        {
                            Write-host " HostUp     " -ForegroundColor Green -NoNewline
                        }
                        else
                        {
                            Write-Host " HostDown   " -ForegroundColor Red -NoNewline
                        } 
                        
                        Write-Host "| $Protocol      | " -NoNewline
                        Write-Host "$currentPort" -ForegroundColor Red
                    }
                    else
                    {
                    ''|select @{n='Source';e={$Source}},`
                              @{n='Destination';e={$Target.toupper()}},`
                              @{n='Protocol';e={$Protocol}},`
                              @{n='Port';e={$CurrentPort}},`
                              @{n='Open';e={$false}}, `
                              @{n='HostUp?';e={If($HostStatus -eq 'success'){$True}else{$false}}} 
                    }

                    #$_.exception.message
                }
                Finally
                {
                    $TCPClient.Close()
                }            
            }
            Else
            {   
                                                              
                # Create object for connecting to port on computer   
                $UDPClient = new-Object system.Net.Sockets.Udpclient 
                
                # Set a timeout on receiving message, to avoid source machine to Listen forever. 
                $UDPClient.client.ReceiveTimeout = $UDPTimeOut
                
                # Datagrams must be sent with Bytes, hence the text is converted into Bytes
                $ASCII = new-object system.text.asciiencoding
                $Bytes = $ASCII.GetBytes("Hi")
                
                # UDP datagram is send
                [void]$UDPClient.Send($Bytes,$Bytes.length,$Target,$CurrentPort)  
                $RemoteEndpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any,0)  
                 
                Try
                {
                    # Waits for a UDP response until timeout defined above
                    $RCV_Bytes = $UDPClient.Receive([ref]$RemoteEndpoint)  
                    $RCV_Data = $ASCII.GetString($RCV_Bytes) 
                    If($RCV_Data) 
                    {
                        If($Iterate)
                        {
                                Write-host "$((hostname).toupper()) | $($Target.toupper())$(Add-Space $Target.length $MaxStringLength) |" -NoNewline
                                if($HostStatus -eq 'Success')
                                {
                                    Write-host " HostUp     " -ForegroundColor Green -NoNewline
                                }
                                else
                                {
                                    Write-Host " HostDown   " -ForegroundColor Red -NoNewline
                                } 
                                
                                Write-Host "| $Protocol      | " -NoNewline
                                Write-Host "$currentPort" -ForegroundColor Red
                        }
                        else
                        {
                            ''|select @{n='Source';e={$Source}},`
                                      @{n='Destination';e={$Target.toupper()}},`
                                      @{n='Protocol';e={$Protocol}},`
                                      @{n='Port';e={$CurrentPort}},`
                                      @{n='Open';e={$true}}, `
                                      @{n='HostUp?';e={If($HostStatus -eq 'success'){$True}else{$false}}} 
                        }
                    }
                }
                catch
                {
                    If($Iterate)
                    {
                        Write-host "$((hostname).toupper()) | $($Target.toupper())$(Add-Space $Target.length $MaxStringLength) |" -NoNewline
                        if($HostStatus -eq 'Success')
                        {
                            Write-host " HostUp     " -ForegroundColor Green -NoNewline
                        }
                        else
                        {
                            Write-Host " HostDown   " -ForegroundColor Red -NoNewline
                        } 
                        
                        Write-Host "| $Protocol      | " -NoNewline
                        Write-Host "$currentPort" -ForegroundColor Red
                    }
                    else
                    {
                    ''|select @{n='Source';e={$Source}},`
                              @{n='Destination';e={$Target.toupper()}},`
                              @{n='Protocol';e={$Protocol}},`
                              @{n='Port';e={$CurrentPort}},`
                              @{n='Open';e={$false}}, `
                              @{n='HostUp?';e={If($HostStatus -eq 'success'){$True}else{$false}}} 
                    } 
                }
                Finally
                {
                
                    # Disposing Variables
                    $UDPClient.Close()
                    $RCV_Data=$RCV_Bytes=$null
                }                                    
            }

        }
    }
}
end{}

}

<#
.Synopsis
   This fucntion is Powershell alternative to Telnet command
.DESCRIPTION
   Function enables you to Telnet Ports from [Local/Remote] Source location to Remote Destinations
.EXAMPLE
   PS > Test-Port -Destination '10.196.10.50'-Port 20,21,135

   Source      : ND10ANLPC100
   Destination : 10.196.10.50
   Protocol    : TCP
   Port        : 20
   Open        : False
   HostUp?     : True
   
   Source      : ND10ANLPC100
   Destination : 10.196.10.50
   Protocol    : TCP
   Port        : 21
   Open        : False
   HostUp?     : True
   
   Source      : ND10ANLPC100
   Destination : 10.196.10.50
   Protocol    : TCP
   Port        : 135
   Open        : True
   HostUp?     : True

   NOTE : If you don't mention -Source as an input, you local machine would be considered as the source of Telnet Client

.EXAMPLE
   To get the continous Port ping on a list of ports use '-Iterate' switch, with the function and you'll see color codes [RED/GREEN] if ports are open or closed.

   PS > Test-Port -Destination '127.0.0.1','10.196.110.150' -Port 20,21,25,53,80,135,3389 -Protocol udp -Iterate

   Source       | Destination     | HostStatus | Protocol | Port
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 20
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 21
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 25
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 53
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 80
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 135
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 3389
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 20
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 21
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 25
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 53
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 80
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 135
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 3389
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 20
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 21
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 25
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 53
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 80
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 135
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 3389
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 20
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 21
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 25
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 53
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 80
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 135
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 3389
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 20
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 21
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 25
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 53
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 80
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 135
   ND10ANLPC100 | 127.0.0.1       | HostUp     | UDP      | 3389
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 20
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 21
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 25
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 53
   ND10ANLPC100 | 10.196.110.150  | HostDown   | UDP      | 80

#>
Function Test-Port
{

[cmdletbinding()]
Param
(
    [Parameter(Position=0)] $Source = $(Hostname),
    [Parameter(Mandatory=$true,Position=1)] $Destination,
    [Parameter(Mandatory=$true,Position=2)]
    [ValidateScript({
                        If($_ -match "^[0-9]+$"){$True}
                        else{Throw "A port should be a numeric value, and $_ is not a valid number"}
    })] $Port,
    [Parameter(Position=3)][ValidateSet('TCP','UDP')] $Protocol = 'TCP',
    [Int] $TCPTimeOut=1000,
    [Int] $UDPTimeOut=5000,
    [Int] $PingTimeOut=80,
    [Switch] $Iterate
)

Begin
{
    $Protocol = $Protocol.ToUpper()
}
Process
{

    # If $source is a localhost, invoke command is not required and we can test port, withhout credentials
    If($Source -like "127.*" -or $source -like "*$(hostname)*" -or $Source -like 'localhost')
    {

        If($Iterate)
        {
                Write-host "Source$(Add-Space 7 $($Source| ForEach-Object { $_.length } | measure -Maximum | ForEach-Object Maximum)) | Destination$(Add-Space "Destination".Length $($Destination| ForEach-Object { $_.length } | measure -Maximum | ForEach-Object Maximum)) | HostStatus | Protocol | Port "
        }

        Do
        {
            Invoke-Telnet $Destination $Port $Protocol $TCPTimeOut $UDPTimeOut $PingTimeOut
            Start-Sleep -Seconds 1   #Initiate sleep to slow down Continous telnet
    
        }While($Iterate)
       
    }
    Else  #Prompt for credentials when Source is not the local machine.
    {     
        #$Credentials = Get-Credential #-Message "Provide Admin credentials to Telnet from [Remote source] to [Remote destination] machine(s)" 
        $Username = Read-Host "Enter Credentials to Telnet from [Remote source] to [Remote destination] machine(s)`nDomain\Username"
        $Password = Read-Host "Password" -AsSecureString
        $Credentials = [System.Management.Automation.PSCredential]::new($Username,$Password)

        If($Credentials)
        {

            If($Iterate)
            {
                    Write-host "Source$(Add-Space 7 $($Source| ForEach-Object { $_.length } | measure -Maximum | ForEach-Object Maximum)) | Destination$(Add-Space "Destination".Length $($Destination| ForEach-Object { $_.length } | measure -Maximum | ForEach-Object Maximum)) | HostStatus | Protocol | Port "
            }

            Do
            {
                Foreach($Item in $Source)
                {          
                    Invoke-command -ComputerName $Item `
                                   -Credential $Credentials `
                                   -ScriptBlock ${Function:Invoke-Telnet} `
                                   -ArgumentList $Destination,$Port,$Protocol,$TCPTimeOut,$UDPTimeOut,$PingTimeOut,$Iterate                                           
                }
    
                # Sleep to slow down Continous telnet
                Start-Sleep -Seconds 1

            }While($Iterate)
        }
       
    }

}
end{}

}

Export-ModuleMember -Function Test-Port