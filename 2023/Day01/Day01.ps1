$in = .\input.txt -Raw

# $in = @'
# two1nine
# eightwothree
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen
# '@
$map = [ordered]@{'one' = 1; 'two' = 2; 'three' = 3; 'four' = 4; 'five' = 5; 'six' = 6; 'seven' = 7; 'eight' = 8; 'nine' = 9; '1' = 1; '2' = 2; '3' = 3; '4' = 4; '5' = 5; '6' = 6; '7' = 7; '8' = 8; '9' = 9; }
$response = 0

function calibrate {
    param(
        [string]$line,
        [array]$digits = @()
    )

    if ($line.Length -eq 0) {
        return $digits[0] * 10 + $digits[-1]
    }

    foreach ($key in $map.keys) {
        if ($line -match "^$key") {
            $digits += $map[$key]; break
        }
    }

    return calibrate -line $line.Remove(0, 1) -digits $digits
}

function Run-Tests {
    Context 'Run tests' {
        It 'should validate string values' {
            calibrate '1rsatwo' | Should -Be 12
        }
    }
}

Run-Tests

foreach ($line in $in.Split("`r`n")) {
    $response += calibrate -line $line
}

$response


#54627
#55149
#55085
# 54649 - the good andswer


