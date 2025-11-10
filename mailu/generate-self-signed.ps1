# PowerShell script to generate a self-signed certificate and export PEM files
# Requires OpenSSL available in PATH (or run inside WSL)
$certPath = Join-Path $PSScriptRoot 'certs'
if (-not (Test-Path $certPath)) { New-Item -ItemType Directory -Path $certPath | Out-Null }
$fullchain = Join-Path $certPath 'fullchain.pem'
$privkey = Join-Path $certPath 'privkey.pem'
Write-Host "Generating self-signed cert to $certPath"
# Use OpenSSL if available
$openssl = Get-Command openssl -ErrorAction SilentlyContinue
if ($null -ne $openssl) {
    & $openssl.Path req -x509 -nodes -days 365 -newkey rsa:2048 `
        -keyout $privkey `
        -out $fullchain `
        -subj "/CN=mail.milagros.me"
    Write-Host "Created self-signed certificate"
} else {
    Write-Host "OpenSSL not found in PATH. You can generate certs in WSL or install OpenSSL."
}
