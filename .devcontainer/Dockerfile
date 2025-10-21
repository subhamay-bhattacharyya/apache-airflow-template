# Dev Container: Python 3.12 + uv-managed airflow-venv (auto-activated)
FROM python:3.12-slim

# --------------------------------------------------------------------
# Environment
# --------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive \
    REPO_NAME=apache-airflow-template \
    WORKSPACE_DIR=/workspaces/${REPO_NAME} \
    VIRTUAL_ENV=/workspaces/${REPO_NAME}/airflow-venv

# --------------------------------------------------------------------
# Base tools + non-root user
# --------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash sudo ca-certificates git curl \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd -s /bin/bash --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
 && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-vscode \
 && chmod 0440 /etc/sudoers.d/99-vscode

# --------------------------------------------------------------------
# Prepare workspace dir (created at build; repo will mount over it at runtime)
# --------------------------------------------------------------------
RUN mkdir -p ${WORKSPACE_DIR}
WORKDIR ${WORKSPACE_DIR}

# --------------------------------------------------------------------
# Install uv globally
# --------------------------------------------------------------------
RUN curl -fsSL https://astral.sh/uv/install.sh | bash -s -- -y \
 && ln -sf /root/.local/bin/uv /usr/local/bin/uv

# --------------------------------------------------------------------
# Robust auto-creation + auto-activation of the venv at shell start
# (Create at runtime to avoid being hidden by the repo bind mount.)
# --------------------------------------------------------------------
RUN printf '%s\n' \
  '#!/usr/bin/env bash' \
  'set -e' \
  'if [ -d "'"${VIRTUAL_ENV}"'" ]; then' \
  '  : # venv exists' \
  'else' \
  '  if command -v uv >/dev/null 2>&1; then' \
  '    echo "[INFO] Creating airflow-venv with uv (Python 3.12) at: '"${VIRTUAL_ENV}"'"' \
  '    uv venv --python 3.12 "'"${VIRTUAL_ENV}"'"' \
  '  else' \
  '    echo "[WARN] uv not found; creating venv via python -m venv"' \
  '    python3 -m venv "'"${VIRTUAL_ENV}"'"' \
  '  fi' \
  'fi' \
  'if [ -f "'"${VIRTUAL_ENV}"'/bin/activate" ]; then' \
  '  # shellcheck disable=SC1090' \
  '  . "'"${VIRTUAL_ENV}"'/bin/activate"' \
  'fi' \
  > /etc/profile.d/airflow-venv.sh \
 && chmod +x /etc/profile.d/airflow-venv.sh \
 && echo '. /etc/profile.d/airflow-venv.sh' >> /etc/bash.bashrc

# --------------------------------------------------------------------
# Default user + working directory
# --------------------------------------------------------------------
USER ${USERNAME}
WORKDIR ${WORKSPACE_DIR}

# Ensure PATH prefers the venv (once created)
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
