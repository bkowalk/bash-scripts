$HA_IP   = "192.168.1.215"
$PLUG_IP = "192.168.1.123"
$LogFile = "$env:USERPROFILE\kasa_rebooter.log"

# Email configuration
$SmtpServer = "smtp.gmail.com"  
$SmtpPort = 587
$EmailUsername = "bkowalk1@gmail.com"
$EmailPassword = "your-app-password"  

# Health check via HTTP API (401 response is expected and means service is healthy)
$response = Invoke-WebRequest -Uri "http://$($HA_IP):8123/api/" -TimeoutSec 10 -SkipHttpErrorCheck
$isHealthy = ($response.StatusCode -eq 401) -or ($response.StatusCode -eq 200)

if (-not $isHealthy) {
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
