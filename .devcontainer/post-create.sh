#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/apache-airflow-template

if [ ! -d "airflow-venv" ]; then
  echo "[INFO] Creating airflow-venv..."
  python3 -m venv airflow-venv
else
  echo "[INFO] airflow-venv already exists, skipping"
fi

# Activate and upgrade pip
source airflow-venv/bin/activate
pip install --upgrade pip setuptools wheel

echo "source /workspaces/apache-airflow-template/airflow-venv/bin/activate" >> ~/.bashrc
echo "[INFO] airflow-venv setup complete."
