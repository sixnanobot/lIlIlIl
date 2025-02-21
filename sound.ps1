Add-Type -TypeDefinition @"
using System;
using System.Media;
public class SoundPlayer {
    public void PlaySound(string file) {
        SoundPlayer player = new SoundPlayer(file);
        player.PlaySync();
    }
}
"@

$player = New-Object SoundPlayer
$player.PlaySound("https://audio.jukehost.co.uk/PZU15MPUQ6cXQDSIawANs6AzMgRPy58j")
