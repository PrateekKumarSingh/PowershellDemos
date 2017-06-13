function a {
    begin {Write-Host 'begin a'} 
    process {Write-Host "process a: $_"; $_} 
    end {Write-Host 'end a'}
}
function b {
    begin {Write-Host 'begin b'} 
    process {Write-Host "process b: $_"; $_} 
    end {Write-Host 'end b'}
}
function c { 
    Write-Host 'c' 
}

1..3 | a | b | c