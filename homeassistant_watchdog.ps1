$HA_IP   = "192.168.1.215"
$PLUG_IP = "192.168.1.123"
$LogFile = "$env:USERPROFILE\kasa_rebooter.log"

# Email configuration
$SmtpServer = "smtp.gmail.com"  
$SmtpPort = 587
$EmailUsername = "bkowalk1@gmail.com"
$EmailPassword = "your-app-password"  

# Ping the server (one ping, 2s timeout)
$ping = Test-Connection -ComputerName $HA_IP -Count 1 -Quiet

if (-not $ping) {
    Add-Content -Path $LogFile -Value "$(Get-Date): Home assistant $HA_IP not responding. Rebooting via Kasa plug."


    # Send email notification
    try {
        $SecurePassword = ConvertTo-SecureString $EmailPassword -AsPlainText -Force
        $Credential = New-Object System.Management.Automation.PSCredential($EmailUsername, $SecurePassword)

        Send-MailMessage -SmtpServer $SmtpServer -Port $SmtpPort -UseSsl -Credential $Credential `
                        -From $EmailUsername -To $EmailUsername -Subject "Home Assistant Rebooted" `
                        
        Add-Content -Path $LogFile -Value "$(Get-Date): Email notification sent successfully."
    } catch {
        Add-Content -Path $LogFile -Value "$(Get-Date): Failed to send email notification: $($_.Exception.Message)"
    }

    # Turn plug OFF
    & kasa --host $PLUG_IP off

    Start-Sleep -Seconds 5

    # Turn plug ON
    & kasa --host $PLUG_IP on

    Add-Content -Path $LogFile -Value "$(Get-Date): Power cycled Kasa plug at $PLUG_IP."
} else {
    Add-Content -Path $LogFile -Value "$(Get-Date): Home assistant is healthy."
}
