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

[int]$response = 0

function Conundrum {
    param(
        $line,
        $limits
    )
    Write-Host "Line: $line"
    $in = $line.Split(':')
    [int]$game = $in[0].Split(' ')[1]
    Write-Host "Game $game" -ForegroundColor DarkMagenta

    $valid = $true
    foreach ($atempt in $in[1].Split(';') ){
        write-host "Attempt: $atempt " -ForegroundColor Green
        foreach($val in $atempt.split(',')) {
            write-host "Value: $val" -ForegroundColor yellow
            [int]$value, $key = ($val.trim()).split(' ')
            if ($value -gt $limits[$key]) {
                $valid = $false
                break
            }
        }
    }

    return [int]($valid ? [int]$game : 0)
}

# foreach ($line in $in.Split("`n")) {

# }


# function Run-Tests {
#     Context 'Run tests' {
#         It 'should return valide games number' {
#             Conundrum 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green' , $limits | Should -Be 1
#             Conundrum 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue' , $limits | Should -Be 2
#             Conundrum 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red' , $limits | Should -Be 3
#             Conundrum 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red' , $limits | Should -Be 4
#             Conundrum 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green' , $limits | Should -Be 5
#         }
#     }
# }


# Run-Tests

foreach ($line in $in.Split("`r`n")) {
    $r = (Conundrum -line $line -limits $limits)
    $r.GetType()
    $response = $response + $r

}

$response


#54627
#55149
#55085
# 54649 - the good andswer


