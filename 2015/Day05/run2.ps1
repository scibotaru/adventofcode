# A nice string is one with all of the following properties:


# - It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
# - It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.

# For example:

# - qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly one letter between them (zxz).
# - xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though the letters used by each rule overlap.
# - uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
# - ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears twice.

$input = Get-Content .\in

function validate {
    param ($in)
    #Write-Host "Processing '$in'"
    $i = 1
    $goodKey = $goodChar = ''
    $wordHasNoPair = $true
    $charHasNoPair = $true
    $shortLenght = $in.Length - 1
    foreach ($c in $in.GetEnumerator()) {
        if ($i -le $shortLenght - 2) {
            $key = "$c$($in[$i])"
            if ($wordHasNoPair -and $in -match "$key(.+)?$key") {
                $goodKey = $key
                $wordHasNoPair = $false
            }
            if ($charHasNoPair -and $in -match "$c.$c") {
                $goodChar = $c
                $charHasNoPair = $false
            }
        }
        $i++

    }
    if ( -not($charHasNoPair) -and -not($wordHasNoPair)) {
        Write-Host "$in - $goodKey - $goodChar - $charHasNoPair - $wordHasNoPair"
        return 1
    }

    return 0
}

$sum = 0

foreach ($in in $input.Split('`r`n')) {
    $sum += validate $in
}

Write-Output "Sum: $sum"

function start-tests {
    validate 'qjhvhtzxzqqjkmpb' | Should -Be 1
    validate 'xxyxx' | Should -Be 1
    validate 'uurcxstgmygtbstg' | Should -Be 0
    validate 'ieodomkazucvgmuy' | Should -Be 0
}

#start-tests

# < 206
# <> 43
# = 51
