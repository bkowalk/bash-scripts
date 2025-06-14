# Get script directory and load configuration
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigFile = Join-Path $ScriptDir ".watchdog_config"

if (Test-Path $ConfigFile) {
    Get-Content $ConfigFile | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            $varName = $matches[1].Trim()
            $varValue = $matches[2].Trim().Trim('"')
            Set-Variable -Name $varName -Value $varValue
        }
    }
} else {
    Write-Error "Configuration file not found: $ConfigFile"
    exit 1
}  

# Health check via HTTP API
$response = Invoke-WebRequest -Uri "http://$($HA_IP):8123/manifest.json" -TimeoutSec 5
$isHealthy = $response.StatusCode -eq 200

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
