Function Test-Latency
{
    [CmdletBinding()]
    Param(
        # ValueFromPipelineByPropertyName 
        # Property Name of the Object from pipeline should match property name 
        # of the the cmdlet param that accepts pipeline input to bind them
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)] [String[]]$Target
    )
        Begin{
            $Packetcount = 4
            Write-Verbose "[In Begin block]"
        }
        Process{      
            Write-Verbose "[In Process block] Checking target : $Target ..." 

            foreach($c in $Target)
            {
                Test-Connection -ComputerName $c -Count $Packetcount | `
                Measure-Object ResponseTime -Maximum -minimum | `
                Select-Object @{name='Target';expression={$c}},  
                @{name='Packet Count';expression={$Packetcount}},
                @{name='Maximum Time(ms)';expression={$_.Maximum}}, 
                @{name='Minimum Time(ms)';expression={$_.Minimum}}
            } 
        }
        end{
                Write-Verbose "[In End block]"
        }
} 

Import-Csv .\Target.csv 
Import-Csv .\Target.csv | Get-Member

Import-Csv .\Target.csv | Test-Latency -Verbose      
Trace-command  -Expression { 1,2,3| Test-Latency -Verbose} -Name parameter* -PSHost