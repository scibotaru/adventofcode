
$input = Get-Content .\in2

# $input = @'
# 123 -> x
# 456 -> y
# x AND y -> d
# x OR y -> e
# x LSHIFT 2 -> f
# y RSHIFT 2 -> g
# NOT x -> h
# NOT y -> i
# '@

Get-Date -Format 'hh:mm:ss START'

$result = [ordered]@{}
$run = $true
$i = 0

function Set-Values {
    param($name, $value)
    Write-Host "Replace $name -> $value"
    foreach ($tt in $result.Keys) {
        $item = $result[$tt]
        if ($item.psobject.BaseObject.Count -gt 1) {
            if ($item.a -eq $name) {
                Write-Host "Replace $name in $tt"
                $result[$tt].a = [UInt16]$value
            }
            if ($null -ne $item.b -and $item.b -eq $name) {
                Write-Host "Replace $name in $tt"
                $result[$tt].b = [UInt16]$value
            }
            if ($null -ne $item.c -and $item.c -eq $name) {
                Write-Host "Replace $name in $tt"
                $result[$tt].c = [UInt16]$value
            }
        }
    }
}

foreach ($in in $input.Split("`r`n")) {
    $s = $in.Split(' -> ')
    $t = $s[0].split(' ')
    $a = ($null -ne $result[$t[0]] -and $result[$t[0]] -match '^\d+$') ? $result[$t[0]]:$t[0]

    if ($t.Count -gt 1) {
        $b = ($null -ne $result[$t[1]] -and $result[$t[1]] -match '^\d+$') ? $result[$t[1]] : $t[1]
        $c = ($null -ne $result[$t[-1]] -and $result[$t[-1]] -match '^\d+$') ? $result[$t[-1]] : $t[-1]
    }
    switch -regex ($in) {
        '.+ AND .+' {
            $result[$s[1]] = @{a = $a; b = $c; op = '-band' ; input = $in }
            break
        }
        '.+ OR .+' {
            $result[$s[1]] = @{a = $a; b = $c; op = '-bor' ; input = $in }
            break
        }
        '.+ LSHIFT .+' {
            $result[$s[1]] = @{a = $a; b = $c; op = '-shl' ; input = $in }
            break
        }
        '.+ RSHIFT .+' {
            $result[$s[1]] = @{a = $a; b = $c; op = '-shr'; input = $in }
            break
        }
        'NOT .+' {
            $result[$s[1]] = @{a = $b; op = '-bnot'; input = $in }
            break
        }
        '^\w+ -> \w+$' {
            $result[$s[1]] = @{ a = $a; op = 'ref' ; input = $in }
            break
        }
        default {
            Write-Host "Error: $in"
        }
    }
}

#-and  -lt 3
while ($run ) {
    $run = $false
    Write-Host $i
    For ($tt = 0; $tt -lt $result.Count; $tt++) {
        #$result[$tt] | Get-Member
        $item = $result[$tt]
        if ($item.psobject.BaseObject.Count -gt 1) {
            $key = $result.keys[$tt]
            switch -regex ($item.op) {
                'ref' {
                    #Write-Host "$key-$($item.a) $($item.a)" -ForegroundColor Green
                    if ($item.a -match '\d+') {
                        $result[$tt] = [UInt16]$item.a
                        Set-Values -name $key -value $item.a
                    } else {
                        $run = $true
                    }
                    break
                }
                '-(shr|shl|bor|band)' {
                    #Write-Host "$($key): $($item.a) $($item.op) $($item.b)" -ForegroundColor Yellow
                    if ($item.a -match '\d+' -and $item.b -match '\d+') {
                        $x = $(65536 + (Invoke-Expression "$($item.a) $($item.op) $($item.b)")) % 65536
                        Write-Host $key -ForegroundColor blue
                        $result[$tt] = $x
                        Set-Values -name $key -value $x
                    } else {
                        $run = $true
                    }
                    break
                }
                '-bnot' {
                    #Write-Host "$($key): $($item.Value.a) $($item.Value.op) " -ForegroundColor Cyan
                    if ($($item.a) -match '^\d+$') {
                        $x = $(65536 + (Invoke-Expression "$($item.op) $($item.a)")) % 65536
                        #Write-Host $key -ForegroundColor Cyan
                        $result[$tt] = $x
                        Set-Values -name $key -value $x
                    } else {
                        $run = $true
                    }
                    break
                }
                default {
                    # if ($item.Value.op -eq 'ref') {
                    # }
                }
            }
        }

        # if ($in -match '^\d+ -> \w') {
        #     $s = $in.Split(' -> ')
        #     $result[$s[1]] = $s[0]
        # }
    }
    $i++
}
# }
# foreach ($in in $input.Split("`r`n")) {
#     #write-host "'$in'"
#     $s = $in.Split(' -> ')
#     switch -regex ($in) {
#         '.+ AND .+' {
#             $t = $s[0].split(' AND ')
#             $result[$s[1]] = $result[$t[0]] -band $result[$t[1]]
#             break
#         }
#         '.+ OR .+' {
#             $t = $s[0].split(' OR ')
#             $result[$s[1]] = $result[$t[0]] -bor $result[$t[1]]
#             break
#         }
#         '.+ LSHIFT .+' {
#             $t = $s[0].split(' LSHIFT ')
#             $result[$s[1]] = $(65536 + ($result[$t[0]] -shl $t[1])) % 65536
#             break
#         }
#         '.+ RSHIFT .+' {
#             $t = $s[0].split(' RSHIFT ')
#             $result[$s[1]] = $(65536 + ($result[$t[0]] -shr $t[1])) % 65536
#             break
#         }
#         'NOT .+' {
#             $t = $s[0].remove(0, 4)
#             $result[$s[1]] = $(65536 + (-bnot $result[$t])) % 65536
#             break
#         }
#     }
# }

$expected = @{
    d = 72
    e = 507
    f = 492
    g = 114
    h = 65412
    i = 65079
    x = 123
    y = 456
}
function Run-D07Tests {
    # Describe 'Run tests' {
    #     Context 'Run Tests' {
    foreach ($key in $result.Keys) {
        "$key  $($result[$key])  $($expected[$key])"
    }
    #     }
    # }
}
#Run-D07Tests

Get-Date -Format 'hh:mm:ss END'

# $result
