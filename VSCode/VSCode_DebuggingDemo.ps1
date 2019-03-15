$Sum = 0
$Iteration = 0
$Message = ''
ForEach($item in 1..10){
    $Sum = $Sum + $item
    If($Sum -lt 10){
        $Message = "Sum is less than 10 and Next item is $($item+1)"
    }
    else {
        $Message = "Sum is greater than 10 and Next item is $($item+1)"
    }
    
    $Iteration++
    Write-Host $Message -ForegroundColor Yellow
}