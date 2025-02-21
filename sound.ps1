$path = "a.wav"
iwr -Uri "https://audio.jukehost.co.uk/gRKoaYb8aW7TTgJ2C1S3jp5g2WTZlMGF" -OutFile $path
$soundplayer = New-Object Media.SoundPlayer $path
$soundplayer.PlaySync()
