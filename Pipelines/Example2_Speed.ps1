# Measuring the Speed
(Measure-Command {  $service = Get-Service
                    foreach($item in $service){
                        ($item.DisplayName -replace " ","-").toUpper()
                    } 
}).totalmilliseconds

(Measure-Command {
                    Get-Service | ForEach-Object {($_.DisplayName -replace " ","-").toUpper()}
}).totalmilliseconds

