#!/bin/bash
# ============================================================
# setup_vm_linux.sh
# Run this script ON THE VM after creation
# Usage: bash setup_vm_linux.sh
# ============================================================
set -e

echo "========================================="
echo " VM Setup — Any6D + YOLOE"
echo "========================================="

# ── 1. Install Docker ─────────────────────────────────────────
echo "[1/6] Installing Docker..."
sudo apt-get update -q
sudo apt-get install -y docker.io docker-compose-v2
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
echo "  → Docker installed ✅"

# ── 2. Install NVIDIA Container Toolkit ──────────────────────
echo "[2/6] Installing NVIDIA Container Toolkit..."
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
  | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
  | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
  | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update -q
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
echo "  → NVIDIA Container Toolkit installed ✅"

# ── 3. Verify GPU ─────────────────────────────────────────────
echo "[3/6] Verifying GPU..."
docker run --rm --gpus all nvidia/cuda:12.1.1-base-ubuntu22.04 nvidia-smi
echo "  → GPU verified ✅"

# ── 4. Clone project ──────────────────────────────────────────
echo "[4/6] Cloning project..."
cd ~
git clone https://github.com/josue-do-it/open-vocabulary-6d-pose-yoloe.git
cd open-vocabulary-6d-pose-yoloe
git clone https://github.com/taeyeopl/Any6D.git
echo "  → Project cloned ✅"

# ── 5. Setup Python environment ───────────────────────────────
echo "[5/6] Setting up Python environment..."
sudo apt-get install -y python3.10-venv libgl1-mesa-glx libglib2.0-0
bash setup_master_env.sh
source master_env/bin/activate
pip install timm trimesh
echo "  → Python environment ready ✅"

# ── 6. Build Any6D Docker ─────────────────────────────────────
echo "[6/6] Building Any6D Docker image..."
cd Any6D
docker system prune -af
bash build_any6d.sh
echo "  → Any6D Docker image built ✅"

echo ""
echo "========================================="
echo " Setup complete!"
echo ""
echo " To run the pipeline:"
echo "   source master_env/bin/activate"
echo "   jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
echo "========================================="
