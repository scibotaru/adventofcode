


# - > delivers presents to 2 houses: one at the starting location, and one to the east.
# - ^>v< delivers presents to 4 houses in a square, including twice to the house at his starting/ending location.
# - ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2 houses.

$in = Get-Content .\in -Raw


function calculate1 {
    param (
        [string] $in
    )

    $houses = @{}

    $posX = $posY = 0

    foreach ($move in $in.GetEnumerator()) {
        $key = "$posX,$posY"
        switch ($move) {
            '^' {
                $posY++; break
            }
            'v' {
                $posY--; break
            }
            '>' {
                $posX++; break
            }
            '<' {
                $posX--; break
            }
            default {
                Write-Host "Unknown carracter: $move"; break
            }
        }
        $houses[$key] = $houses[$key] + 1
    }

    return $houses.Count
}


function calculate2 {
    param (
        [string] $in
    )

    $houses = @{}
    $houses['0,0'] = 1

    $posX = $posY = $posXR = $posYR = $step = 0

    foreach ($move in $in.GetEnumerator()) {
        if ($step++ % 2 -eq 0) {
            switch ($move) {
                '^' {
                    $posY++; break
                }
                'v' {
                    $posY--; break
                }
                '>' {
                    $posX++; break
                }
                '<' {
                    $posX--; break
                }
                default {
                    Write-Host "Unknown carracter: $move"; break
                }
            }
            $key = "$posX,$posY"
            #write-host "Santa's run: $key"
        } else {
            switch ($move) {
                '^' {
                    $posYR++; break
                }
                'v' {
                    $posYR--; break
                }
                '>' {
                    $posXR++; break
                }
                '<' {
                    $posXR--; break
                }
                default {
                    Write-Host "Unknown carracter: -$move-"; break
                }
            }
            $key = "$posXR,$posYR"
            #Write-Host "Robot's run: $key"
        }
        $houses[$key] = $houses[$key] + 1
    }

    return $houses.Count
}

# function tests {
#     Describe 'Tests' {

#     }
# }

# tests
# calculate1 '>'#| Should -Be 1
# calculate1 '^>v<' #| Should -Be 4
# calculate1 '^v^v^v^v^v'# | Should -Be 2






calculate1 $in
calculate2 $in

# calculate2 '^v'#| Should -Be 3
# calculate2 '^>v<' #| Should -Be 3
# calculate2 '^v^v^v^v^v'# | Should -Be 11
