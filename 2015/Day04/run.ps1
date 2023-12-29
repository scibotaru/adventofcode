function md5 {
    param ($in)
    return ([System.BitConverter]::ToString((New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider).ComputeHash((New-Object -TypeName System.Text.UTF8Encoding).GetBytes($in)))).Replace('-', '')

}
Set-Variable key = 0
$in = 'yzbqklnj'
$r = 0..33 | ForEach-Object -ThrottleLimit 10 -Parallel {
    Write-Host $_
    foreach ($i in ($_ * 1000000)..($_ * 1000000 + 999999)) {
        $hash = ([System.BitConverter]::ToString((New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider).ComputeHash((New-Object -TypeName System.Text.UTF8Encoding).GetBytes("$using:in$i"))))
        if($i%100000 -eq 0) {write-host "$using:in-$i-$hash"}
        if ($hash -match '^00-00-00') {
            Write-Host "$using:in-$i-$hash" -ForegroundColor Green
            "$using:in-$i-$hash" >> .\response.txt
            exit
        }
    }

}

$answer = "$in$r"

Write-Host "Response for '$in' key is: $answer ($r)"

#9962624
