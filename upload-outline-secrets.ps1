# PowerShell script to upload Outline .env secrets to GitHub repository environment (production)
# Requires: GitHub CLI (gh) installed and authenticated
# Usage: .\upload-outline-secrets.ps1 -EnvFile ".env" -Repo "Moneybook-ve/outline-server" -Environment "production"

param(
    [string]$EnvFile = ".env",
    [string]$Repo = "Moneybook-ve/outline-server",
    [string]$Environment = "production"
)

# List of secrets that should NOT be uploaded (server-specific)
$excludeSecrets = @(
    "HETZNER_PASSWORD",
    "HETZNER_USER", 
    "HETZNER_HOST",
    "HETZNER_PROJECT_PATH",
    "HETZNER_API_TOKEN"
)

# Mapping of local env var names to GitHub secret names
$secretMapping = @{
    "URL" = "OUTLINE_URL"
}

if (!(Test-Path $EnvFile)) {
    Write-Error "Environment file '$EnvFile' not found."
    exit 1
}

$lines = Get-Content $EnvFile
foreach ($line in $lines) {
    if ($line -match "^(\w+)=(.*)$") {
        $name = $matches[1]
        $value = $matches[2]
        
        # Skip excluded secrets
        if ($excludeSecrets -contains $name) {
            Write-Host "Skipping server-specific secret: $name"
            continue
        }
        
        # Map local variable names to GitHub secret names
        $secretName = if ($secretMapping.ContainsKey($name)) { $secretMapping[$name] } else { $name }
        
        Write-Host "Uploading secret: $secretName"
        gh secret set $secretName --body "$value" --repo $Repo --env $Environment
    }
}
Write-Host "All eligible Outline secrets uploaded to environment '$Environment' in repo '$Repo'."