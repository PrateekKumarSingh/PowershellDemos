#  (gci .\bigFile.txt).length /1mb

$content = Get-Content .\bigFile.txt
$result = @()
foreach($item in $content)
{
    If($item -like "*pipe*")
    {
        $result =  $result + $item   
    }
}
$result

# ($content).Where({$_ -like "*pipe*"})

Get-Content C:\Demo\bigFile.txt | Where-Object {$_ -like "*pipe*"} -OutVariable result2