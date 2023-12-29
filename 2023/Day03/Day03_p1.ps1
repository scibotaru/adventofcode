$in = Get-Content .\day02.txt -Raw

$in = @'
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
'@

[Int64]$response = 0

$x = $in.Split("`r`n").Length
$y = $in.Split("`r`n")[0].length

$array = New-Object 'object[,]' $y, $x
$i = 0
foreach ($line in $x = $in.Split("`r`n")) {
    $j = 0
    $line.GetEnumerator() | ForEach-Object { $array[ $j++, $i] = $_ }
    $i++
}
$z[2, 2]
function numbersAround {
    param (
        $array,
        $x,
        $y
    )

    return 1
}

foreach ($line in $array) {
    foreach ($char in $line) {
        #if ([int]$char -notin(46,48..57)) {
            [int]$char.GetType()
            exit
        #}
    }
}


function GearRatios {
    param(
        $line,
        $limits
    )
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
}


# function Run-Tests {

#     Conundrum -line 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green' -limits $limits | Should -Be 48
#     Conundrum -line 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue' -limits $limits | Should -Be 12
#     Conundrum -line 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red' -limits $limits | Should -Be 1560
#     Conundrum -line 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red' -limits $limits | Should -Be 630
#     Conundrum -line 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green' -limits $limits | Should -Be 36
# }


# Run-Tests

foreach ($line in $in.Split("`r`n")) {
    $response += (GearRatios )

}

$response




