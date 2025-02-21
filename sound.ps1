$mp3Url = "https://audio.jukehost.co.uk/PZU15MPUQ6cXQDSIawANs6AzMgRPy58j"
$mp3Path = "$env:Temp\temp.mp3"
Invoke-WebRequest -Uri $mp3Url -OutFile $mp3Path
Add-Type -TypeDefinition @"
using System;
using System.Media;
public class SoundPlayer {
    public void PlaySound(string file) {
        var player = new System.Media.SoundPlayer(file);
        player.PlaySync();
    }
}
"@
$player = New-Object SoundPlayer
$player.PlaySound($mp3Path)
