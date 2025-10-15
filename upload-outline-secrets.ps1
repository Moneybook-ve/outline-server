# PowerShell script to upload Outline .env secrets to GitHub repository environment (production)
# Requires: GitHub CLI (gh) installed and authenticated
# Usage: .\upload-outline-secrets.ps1 -EnvFile ".env" -Repo "Moneybook-ve/outline-server" -Environment "production"

param(
    [string]$EnvFile = ".env",
    [string]$Repo = "Moneybook-ve/outline-server",
    [string]$Environment = "production"
)

if (!(Test-Path $EnvFile)) {
    Write-Error "Environment file '$EnvFile' not found."
    exit 1
}

$lines = Get-Content $EnvFile
foreach ($line in $lines) {
    if ($line -match "^(\w+)=(.*)$") {
        $name = $matches[1]
        $value = $matches[2]
        Write-Host "Uploading secret: $name"
        gh secret set $name --body "$value" --repo $Repo --env $Environment
    }
}
Write-Host "All Outline secrets uploaded to environment '$Environment' in repo '$Repo'."