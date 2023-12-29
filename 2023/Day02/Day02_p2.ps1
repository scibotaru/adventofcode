$in = .\input.txt -Raw

# $in = @'
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# '@

# $limits = @{
#     blue  = 4
#     red   = 3
#     green = 5
# }
$limits = @{
    blue  = 14
    red   = 12
    green = 13
}

[Int64]$response = 0

function Conundrum {
    param(
        $line,
        $limits
    )
    $minLmits = @{
        blue  = 0
        red   = 0
        green = 0
    }
    $in = $line.Split(':')
    #[int]$game = $in[0].Split(' ')[1]

    $valid = $true
    foreach ($atempt in $in[1].Split(';') ) {
        foreach ($val in $atempt.split(',')) {
            [int]$value, $key = ($val.trim()).split(' ')
            # if ($value -gt $limits[$key]) {
            #     $valid = $false
            #     break
            # }
            if ($minLmits[$key] -lt $value) {
                $minLmits[$key] = $value
            }
        }
    }

    # if ($valid) {
    $game = 1
    $minLmits.Keys | ForEach-Object { $game *= ($minLmits[$_] -gt 0 ? $minLmits[$_] : 1) }
    return $game
    # } else {
    #     return 0
    # }
}


function Run-Tests {

    Conundrum -line 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green' -limits $limits | Should -Be 48
    Conundrum -line 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue' -limits $limits | Should -Be 12
    Conundrum -line 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red' -limits $limits | Should -Be 1560
    Conundrum -line 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red' -limits $limits | Should -Be 630
    Conundrum -line 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green' -limits $limits | Should -Be 36
}


# Run-Tests

foreach ($line in $in.Split("`r`n")) {
    $response += (Conundrum -line $line -limits $limits)

}

$response




