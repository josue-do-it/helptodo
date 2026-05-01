# ============================================================
# setup_windows.ps1
# Run this script ON WINDOWS (PowerShell as Admin)
# to connect VS Code to your GCP VM
# Usage: .\setup_windows.ps1
# ============================================================

$PROJECT_ID = "josue-project-485119"   # ← your project ID
$VM_NAME    = "josue-l4-vm"            # ← your VM name
$ZONE       = "us-central1-b"          # ← your zone
$USERNAME   = "josue_aims_ac_za"       # ← your GCP username

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Windows Setup — Connect VS Code to GCP VM" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# ── 1. Fix .ssh folder permissions ───────────────────────────
Write-Host "[1/4] Fixing SSH permissions..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "C:\Users\$env:USERNAME\.ssh" | Out-Null
icacls "C:\Users\$env:USERNAME\.ssh" /inheritance:r | Out-Null
icacls "C:\Users\$env:USERNAME\.ssh" /grant:r "$env:USERDOMAIN\$env:USERNAME`:F" | Out-Null
Write-Host "  → SSH folder permissions fixed ✅" -ForegroundColor Green

# ── 2. Generate SSH config ────────────────────────────────────
Write-Host "[2/4] Generating SSH config..." -ForegroundColor Yellow
gcloud compute config-ssh --project=$PROJECT_ID

# Fix config file permissions
icacls "C:\Users\$env:USERNAME\.ssh\config" /inheritance:r | Out-Null
icacls "C:\Users\$env:USERNAME\.ssh\config" /grant:r "$env:USERDOMAIN\$env:USERNAME`:F" | Out-Null
icacls "C:\Users\$env:USERNAME\.ssh\config" /remove "NT AUTHORITY\Authenticated Users" | Out-Null
icacls "C:\Users\$env:USERNAME\.ssh\config" /remove "BUILTIN\Users" | Out-Null
Write-Host "  → SSH config generated ✅" -ForegroundColor Green

# ── 3. Update ProxyCommand to use gcloud.cmd ─────────────────
Write-Host "[3/4] Updating SSH config ProxyCommand..." -ForegroundColor Yellow
$gcloudPath = (Get-Command gcloud).Source -replace '\.ps1$', '.cmd'
$sshConfig = Get-Content "C:\Users\$env:USERNAME\.ssh\config" -Raw
$sshConfig = $sshConfig -replace 'ProxyCommand gcloud ', "ProxyCommand `"$gcloudPath`" "
[System.IO.File]::WriteAllText("C:\Users\$env:USERNAME\.ssh\config", $sshConfig)
Write-Host "  → ProxyCommand updated ✅" -ForegroundColor Green

# ── 4. Test SSH connection ────────────────────────────────────
Write-Host "[4/4] Testing SSH connection..." -ForegroundColor Yellow
$result = gcloud compute ssh $VM_NAME `
    --zone=$ZONE `
    --project=$PROJECT_ID `
    --tunnel-through-iap `
    --command="echo connection_ok" 2>&1

if ($result -match "connection_ok") {
    Write-Host "  → SSH connection working ✅" -ForegroundColor Green
} else {
    Write-Host "  → SSH test output: $result" -ForegroundColor Yellow
    Write-Host "  → Type 'y' if asked to store key" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host " To connect VS Code to the VM:" -ForegroundColor White
Write-Host "   1. Open VS Code" -ForegroundColor Gray
Write-Host "   2. Ctrl+Shift+P → Remote-SSH: Connect to Host" -ForegroundColor Gray
Write-Host "   3. Select: $VM_NAME.$ZONE.$PROJECT_ID" -ForegroundColor Gray
Write-Host "   4. Select platform: Linux" -ForegroundColor Gray
Write-Host ""
Write-Host " To transfer files to VM:" -ForegroundColor White
Write-Host "   gcloud compute scp --recurse `"D:\your\project`" $USERNAME@${VM_NAME}:~/ --zone=$ZONE --project=$PROJECT_ID --tunnel-through-iap" -ForegroundColor Gray
Write-Host "=========================================" -ForegroundColor Cyan
