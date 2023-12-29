# A nice string is one with all of the following properties:

# - It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
# - It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa,bb, cc, or dd).
# - It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.


# - ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
# - aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
# - jchzalrnumimnmhp is naughty because it has no double letter.
# - haegwjzuvuyypxyu is naughty because it contains the string xy.
# - dvszwmarrgswjxmb is naughty because it contains only one vowel.
$input = Get-Content .\in
function validate {
    param ($in)
    #Write-Host "Processing '$in'"
    if ($in -match '(ab|cd|pq|xy)') {
        return 0
    }
    $vocalCount = 0
    $i = 1
    $noConsecutive = $true
    $l = $in.Length - 1
    foreach ($c in $in.GetEnumerator()) {
        if ($c -match '(a|e|i|o|u)') {
            $vocalCount = $vocalCount + 1
        }
        if ($noConsecutive -and $i -le $l -and ($c -ceq $in[$i++])) {
            $noConsecutive = $false
        }
    }
    #Write-Host "$i - $vocalCount - $noConsecutive"
    if ($vocalCount -gt 2 -and -not($noConsecutive)) {
        return 1
    }

    return 0
}

$sum = 0

foreach ($in in $input.Split('`r`n')) {
    $sum += validate $in
}

Write-Output "Sum: $sum"

# function start-tests {

#     validate 'ugknbfddgicrmopn' | Should -Be 1
#     validate 'aaa' | Should -Be 1
#     validate 'jchzalrnumimnmhp' | Should -Be 0
#     validate 'haegwjzuvuyypxyu' | Should -Be 0
#     validate 'dvszwmarrgswjxmb' | Should -Be 0
# }

# start-tests
