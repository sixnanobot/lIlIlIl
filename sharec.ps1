netsh advfirewall firewall set rule group=”network discovery” new enable=yes
netsh firewall set service type=fileandprint mode=enable profile=all
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name everyoneincludesanonymous -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters\" -Name restrictnullsessacces -Value 0 -Force
New-SmbShare -Name "Windows Update" -Path "C:\"
