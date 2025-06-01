$HA_IP   = "192.168.1.215"
$PLUG_IP = "192.168.1.123"
$LogFile = "$env:USERPROFILE\kasa_rebooter.log"

# Ping the server (one ping, 2s timeout)
$ping = Test-Connection -ComputerName $HA_IP -Count 1 -Quiet

if (-not $ping) {
    Add-Content -Path $LogFile -Value "$(Get-Date): Home assistant $HA_IP not responding. Rebooting via Kasa plug."

    # Turn plug OFF
    & kasa --host $PLUG_IP off

    Start-Sleep -Seconds 5

    # Turn plug ON
    & kasa --host $PLUG_IP on

    Add-Content -Path $LogFile -Value "$(Get-Date): Power cycled Kasa plug at $PLUG_IP."
} else {
    Add-Content -Path $LogFile -Value "$(Get-Date): Home assistant is healthy."
}
