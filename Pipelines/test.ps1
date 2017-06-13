# double the input
Function f1($x) { $x * 2 }
 
# concatenate the nth letter to the input where n is half the input value
Function f2($x) { "$x" + [char]([byte][char] "A" + $x/2 - 1) }
 
# reverse the 2-character string
Function f3($x) { $x[1..0] -join '' }

1..3|%{f1 $_}|%{f2 $_}|%{f3 $_}


Function test ($a,$b)
{
    $input
}


1,2 | test

get-service b* -PipelineVariable PV| %{$pv.name}


$result = Get-ChildItem -Recurse
foreach


Get-ChildItem C:\Data\Powershell\Scripts *.ps1 -Recurse | se;ect

Measure-Command
|
Sort-Object Name -Descending|
ForEach-Object{
    $pv 
    #$_
}


Get-ChildItem C:\Data\Powershell\Scripts *.ps1 -Recurse| ?{$_.name -like "*.ps1"}

