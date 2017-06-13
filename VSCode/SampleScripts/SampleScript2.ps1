<#
.SYNOPSIS
Remove unwanted files from Directories

.DESCRIPTION
Interactive script to remove unwanted files from Directories, and has capability to exclude specific Files and extensions.

.PARAMETER DriveAlphabet
Drive alphabet like 'C' for C Drive

.PARAMETER Exclude
Mention files and extension to be excluded while cleaning up the drives
You can use it like  -Exclude '*.vhd','*.log','SomeRandomFilename.xlsx'

.PARAMETER DataInGB
Converts all your data in GB's instead of default unit MB

.PARAMETER Interactive
Prompts user to choose folders names to target the cleanup

.EXAMPLE
Cleanup -Interactive -Exclude '*.xlsx','*.log','new text document.txt' -Verbose

.EXAMPLE

Cleanup -Verbose -DataInGB

.EXAMPLE

Cleanup -Interactive -Exclude '*.log','*.xlsx' -EmailTo 'prateek@xyz.com.com','Rohit@xyz.com.com' -Verbose

.NOTES
Author : Prateek Singh

TO DO
a) Use cleanmgr.exe to further clean the c:\
b)
#>  
Function Get-SpaceUtlization
{
    [Alias("Cleanup")]
    [cmdletbinding()]
    Param(
            [Parameter(Position=0)]
            [Alias("Drive")] 
            [String] $DriveAlphabet = "C",
            [String[]] $Exclude,
            [String[]] $EmailTo,
            [Switch] $DataInGB,
            [Switch] $Interactive
    )

        If($DataInGB){$Unit = '1GB';$Metric="GB"}
        else {$Unit = '1MB';$Metric="MB"}

        If($DriveAlphabet -eq "C")
        {
            $FoldersToCheck =   @(
                                    'C:\Windows\Winsxs',
                                    "C:\users\prateek\AppData\Local\Microsoft\Windows\Temporary Internet Files"
                                    'C:\TestFolder1',
                                    'C:\TestFolder2',
                                    'C:\TestFolder3',
                                    'C:\TestFolder4'
                                )
        }

        $LogPath =  "$env:TEMP\DriveCleanup.log"
        Start-Transcript -LiteralPath $LogPath

        Write-Host "Computing and Capturing Current $($DriveAlphabet.toupper()) Drive space utlization ..." -ForegroundColor Yellow
        $Before =   Get-WmiObject Win32_LogicalDisk | `
                    Where-Object {$_.deviceID -eq "$($DriveAlphabet):"} | `
                    Select-Object   @{Name="Drive";Expression={$_.DeviceID}}, `
                                    @{Name="Size ($Metric)";Expression={"{0:N2}" -f ($_.Size/ $Unit)}}, `
                                    @{Name="FreeSpace ($Metric)";Expression={"{0:N2}" -f ($_.Freespace/ $Unit)}}, `
                                    @{Name="PercentageFree";Expression={"{0:P2}" -f ($_.FreeSpace/$_.Size)}} 
                                    #-OutVariable 'Before'                                 
        
        $Before |Out-String
        Write-Host "Populating space utlization of following folder directories `n" -ForegroundColor Yellow
        
        $FoldersToCheck |Out-String
        
        $DirectorySize = ForEach($Directory in $FoldersToCheck)
        {       
            $Files = Get-ChildItem "$Directory" -Verbose -Recurse -ErrorAction SilentlyContinue | `
                     Where-Object{$_.PSIsContainer -eq $false} | `
                     Select-Object FullName, Length, Extension

            [PSCustomObject]@{
                Directory           =   $Directory
                "Size ($Metric)"    =   ("{0:N4}" -f ((( $Files |ForEach-Object length|Measure-Object -Sum).Sum)/ $Unit))
                Files               =   $Files.FullName
                Extension           =   $Files |Select-Object Extension -Unique -ExpandProperty Extension
                FileCount           =   $Files.Count
            }

        }

        If($Interactive) {
            $FilesToDelete = $DirectorySize | Out-GridView -PassThru -Title "Select the folder(s) you want clean, Script will delete all items inside it." 
    
            If($FilesToDelete)
            {
                Write-Host "Total: $($FilesToDelete.Files.count) files would be deleted from the following Directories" -ForegroundColor Yellow
                Write-Host "$($FilesToDelete| select-object Directory, FileCount | Sort-Object FileCount -Descending |Out-String)"
                
                $FilesToDelete|ForEach-Object {
                    Remove-Item "$($_.Directory)\*" -Exclude $Exclude -Recurse -Verbose -Confirm:$false -Force
                }
            }                
        }
        else {

            If($DirectorySize)
            {
                Write-Host "Deleting Total: $($DirectorySize.Files.count) files from the following Diretories" -ForegroundColor Yellow
                Write-Host "$($DirectorySize| select-object Directory, FileCount | Sort-Object FileCount -Descending |Out-String)"
            
                $DirectorySize | ForEach-Object {
                    Remove-Item "$($_.Directory)\*" -Exclude $Exclude -Recurse -Verbose -Confirm:$false  -Force
                }
            }
        }


        $After =    Get-WmiObject Win32_LogicalDisk | `
                    Where-Object {$_.deviceID -eq "$($DriveAlphabet):"} | `
                    Select-Object   @{Name="Drive";Expression={$_.DeviceID}}, `
                                    @{Name="Size ($Metric)";Expression={"{0:N2}" -f ($_.Size/ $Unit)}}, `
                                    @{Name="FreeSpace ($Metric)";Expression={"{0:N2}" -f ($_.Freespace/ $Unit)}}, `
                                    @{Name="PercentageFree";Expression={"{0:P2}" -f ($_.FreeSpace/$_.Size)}} 


        Write-Host "`nBEFORE:" -ForegroundColor Yellow
        Write-Host "$($Before|out-string)"
        Write-Host "AFTER:" -ForegroundColor Yellow                                             
        Write-Host $($After|out-string)

        Stop-Transcript
        Write-Host "A log File: $LogPath has been generated post cleanup"

        If($EmailTo)
        {
            Send-MailMessage    -SmtpServer 'smtp.server' -From "$($env:COMPUTERNAME)_DriveCleanup@xyz.com.com" `
                                -Attachments $LogPath `
                                -To $EmailTo `
                                -Subject "$(($env:COMPUTERNAME).toupper()) | $(($DriveAlphabet).toupper()) Drive cleanup Log | Free % = $($After.PercentageFree)"

        }
}
