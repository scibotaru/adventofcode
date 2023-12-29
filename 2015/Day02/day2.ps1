[CmdletBinding()]
# 2*l*w + 2*w*h + 2*h*l
$in = Get-Content .\in -Raw


Function Get-Paper {
    [CmdletBinding()]
    param(
        $in = '2x3x4'
    )
    #$sizes = [int] @()
    [int32[]]$sizes = $in.Split('x')
    $sizes = $sizes | Sort-Object
    # if ($sizes.Count -ne 3) {
    #     Write-Host 'Count: '$sizes.Count
    #     return 0
    # }
    # $min = [int]::MaxValue
    # $i = $max = $minId = $medId = $maxId = 0
    # ForEach ($size in $sizes) {
    #     Write-Debug "Size: $size; Order: $i"
    #     if ($size -lt $min) {
    #         $min = $size; $minId = $i
    #     }
    #     if ($size -gt $max) {
    #         $max = $size; $maxId = $i
    #     }
    #     $i++
    # }
    # if ($minId -eq $maxId ) {
    #     $medId = $minId
    # } else {
    #     $medId = (0..2) | Where-Object { $_ -ne $maxId } | Where-Object { $_ -ne $minId }
    # }

    # $med = $sizes[$medId]
    $sum = $sizes[0] * $sizes[1] + 2 * $sizes[0] * $sizes[1] + 2 * $sizes[1] * $sizes[2] + 2 * $sizes[2] * $sizes[0]
    $ribbon = $($sizes[0] + $sizes[1]) * 2 + $($sizes[0] * $sizes[1] * $sizes[2])

    #Write-Host "Input: $in,    `tIds: $minId-$medId-$maxId, `tValues: $($sizes -join('-'))    `tSum: $sum"
    return $sum,$ribbon
}
[Int64]$sum, [Int64]$length = 0

foreach ($line in $in.Split("`r`n")) {
    $s,$l = Get-Paper $line
    $length += $l
    $sum += $s
}
#$sum = Get-Paper '2x3x4'
Write-Output "Total size: $sum`nTotal ribbon length: $length"
# function RunTests {
#     # Describe 'Tests' {
#     #     Context 'TT' {
#     Get-Paper '2x3x4' | Should -Be 58
#     Get-Paper '1x1x10' | Should -Be 43
#     #     }
#     # }
# }

#RunTests
# get-paper '14x12x8' | Should -Be 848
# get-paper '14x12x8' -debug:$DebugPreference #| Should -Be 848


# > 606483
# > 1557634
# Correct value:  1606483
# < 1715567
