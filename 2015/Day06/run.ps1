
$input = Get-Content .\in

$map1 = @{}
$map2 = @{}

Get-Date -Format 'hh:mm:ss'
foreach ($i in 0..999) {
    foreach ($j in 0..999) {
        $map1["$i,$j"] = 0
        $map2["$i,$j"] = 0

    }
}
function switcher1 {
    param(
        [int]$value,
        [array]$c1,
        [array]$c2
    )
    if ($value -eq 2) {
        foreach ($i in $([int]$c1[0])..$([int]$c2[0])) {
            foreach ($j in $([int]$c1[1])..$([int]$c2[1])) {
                $map1["$i,$j"] = $map1["$i,$j"] + 1
            }
        }
    } else {
        foreach ($i in $([int]$c1[0])..$([int]$c2[0])) {
            foreach ($j in $([int]$c1[1])..$([int]$c2[1])) {
                $map1["$i,$j"] = $value
            }
        }
    }
}
function switcher2 {
    param(
        [int]$value,
        [array]$c1,
        [array]$c2
    )
    foreach ($i in $([int]$c1[0])..$([int]$c2[0])) {
        foreach ($j in $([int]$c1[1])..$([int]$c2[1])) {
            if ($map2["$i,$j"] + $value -ne -1) {
                $map2["$i,$j"] += $value
            }
        }
    }
}

foreach ($in in $input.Split('`r`n')) {
    (Get-Date -Format 'hh:mm:ss ') + $in

    switch -regex ($in) {
        'turn on *' {
            $coordinates = $in.Remove(0, 8).Split(' ')
            switcher1 -value 1 -c1 ($coordinates[0].split(',')) -c2 ($coordinates[2].split(','))
            switcher2 -value 1 -c1 ($coordinates[0].split(',')) -c2 ($coordinates[2].split(','))
        }
        'turn off *' {
            $coordinates = $in.Remove(0, 9).Split(' ')
            switcher1 -value 0 -c1 ($coordinates[0].split(',')) -c2 ($coordinates[2].split(','))
            switcher2 -value -1 -c1 ($coordinates[0].split(',')) -c2 ($coordinates[2].split(','))
        }
        'toggle *' {
            $coordinates = $in.Remove(0, 7).Split(' ')
            switcher1 -value 2 -c1 ($coordinates[0].split(',')) -c2 ($coordinates[2].split(','))
            switcher2 -value 2 -c1 ($coordinates[0].split(',')) -c2 ($coordinates[2].split(','))
        }
        default {
            'unknown'
        }
    }
}

$sum1 = $sum2 = 0

foreach ($i in 0..999) {
    foreach ($j in 0..999) {
        if ($map1["$i,$j"] % 2 -eq 1) {
            $sum1++
        }
        $sum2 += $map2["$i,$j"]
    }
}

Write-Output "Sum 1: $sum1"
Write-Output "Sum 2: $sum2"

# 377891
# 14110788
