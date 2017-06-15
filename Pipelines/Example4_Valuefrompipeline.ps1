Function Test-Latency
{
    [CmdletBinding()]
    Param(
        # ValueFromPipeline
        # Only Data type of the Object from pipeline should match the data type 
        # of the the cmdlet param that accepts pipeline input to bind the
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)] [String[]]$Target
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

"google.com","facebook.com","linkedin.com"|Test-Latency -Verbose 
"google.com","facebook.com","linkedin.com"|Test-Latency -Verbose |Sort-Object 'Maximum Time(ms)' -Descending
"google.com","facebook.com","linkedin.com"|Test-Latency -Verbose |Where-Object 'Maximum Time(ms)' -gt 100