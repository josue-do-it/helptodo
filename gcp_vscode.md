# How to Install and Use GCP in VS Code on Windows via SSH

## Prerequisites

- A GCP Virtual Machine (VM) instance running
- VS Code installed on Windows
- OpenSSH client enabled on Windows

---

## Step 1 — Install the Remote - SSH Extension in VS Code

1. Open VS Code
2. Go to the **Extensions** panel (`Ctrl + Shift + X`)
3. Search for **Remote - SSH** (by Microsoft)
4. Click **Install**

---

## Step 2 — Start or Connect Your GCP VM

Make sure your VM is running in the [GCP Console](https://console.cloud.google.com/).

---

## Step 3 — Configure Your SSH Config File

Edit or create the file at `C:\Users\<YourUsername>\.ssh\config` and add your VM entry:

```ssh
Host my-gcp-vm
    HostName <YOUR_VM_EXTERNAL_IP>
    User <YOUR_USERNAME>
    IdentityFile C:\Users\<YourUsername>\.ssh\google_compute_engine
```

---

## Step 4 — Fix SSH Config Permissions on Windows

If you see the error **`Bad owner or permissions on .ssh/config`**, fix it by running the following commands in **PowerShell as Administrator**:

```powershell
$path = "C:\Users\$env:USERNAME\.ssh\config"

# Remove inherited permissions
icacls $path /inheritance:r

# Grant full control only to the current user
icacls $path /grant:r "$($env:USERDOMAIN)\$($env:USERNAME):F"
```

> ⚠️ **Important:** Make sure to run PowerShell as **Administrator**, otherwise the `icacls` commands will fail.

---

## Step 5 — Connect to Your VM from VS Code

1. Press `Ctrl + Shift + P` to open the Command Palette
2. Type and select **Remote-SSH: Connect to Host...**
3. Choose your configured host (e.g., `my-gcp-vm`)
4. VS Code will open a new window connected to your GCP VM

---

## Troubleshooting

| Issue | Fix |
|---|---|
| `Bad owner or permissions on .ssh/config` | Run the `icacls` commands in Step 4 as Administrator |
| Connection timeout | Check that your VM is running and the external IP is correct |
| Permission denied (publickey) | Ensure your SSH key is added to GCP metadata |
