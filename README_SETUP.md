# Setup Guide — Any6D + YOLOE Pipeline

---

## Step 1 — Create the VM (Git Bash or WSL on Windows)

```bash
# Edit your username first
nano create_vm.sh
# Change: export AIMSUSERNAME="<your_aims_username>"

# Run
bash create_vm.sh
```

---

## Step 2 — Connect VS Code to VM (Windows PowerShell Admin)

```powershell
# Edit your project info first
nano setup_windows.ps1
# Change: PROJECT_ID, VM_NAME, ZONE, USERNAME

# Run
.\setup_windows.ps1

# Then in VS Code:
# Ctrl+Shift+P → Remote-SSH: Connect to Host → select your VM
```

---

## Step 3 — Setup the VM (Linux terminal in VS Code)

```bash
# Once connected to VM via VS Code terminal
bash setup_vm_linux.sh
```

---

## Files

| File | Platform | Description |
|------|----------|-------------|
| `create_vm.sh` | Git Bash / WSL | Creates GCP VM with L4 GPU |
| `setup_windows.ps1` | PowerShell (Admin) | Fixes SSH + connects VS Code |
| `setup_vm_linux.sh` | Linux (VM terminal) | Installs Docker, Any6D, YOLOE |
| `setup_master_env.sh` | Linux (VM terminal) | Creates Python env for YOLOE |
| `build_any6d.sh` | Linux (VM terminal) | Builds Any6D Docker image |

---

## Daily Workflow

```
1. Start VM → GCP Console → VM instances → Start
2. VS Code → Ctrl+Shift+P → Remote-SSH: Connect to Host
3. Open notebook → YOLOE_Any6D_Pipeline_Final.ipynb
4. Run All
5. Stop VM when done → GCP Console → Stop
```

---

## Cost

| State | Cost |
|-------|------|
| VM Running (L4) | ~$0.70/hour |
| VM Stopped | ~$0.17/day |
| VM Deleted | $0 |
