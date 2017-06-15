# Without Pipeline
$service = Get-Service
$result=@()
foreach($item in $service){
    $result = $result + ($item.DisplayName -replace " ","-").toUpper()
}
$result[1..10]

# With Pipeline
Get-Service | ForEach-Object {($_.DisplayName -replace " ","-").toUpper()} |select -First 10



