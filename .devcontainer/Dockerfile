# Dev Container: Python 3.12 + airflow-venv (auto-activated)
FROM python:3.12-slim

# Environment
ENV DEBIAN_FRONTEND=noninteractive \
    VIRTUAL_ENV=/workspace/airflow-venv \
    PATH="/workspace/airflow-venv/bin:$PATH"

# Minimal tools and non-root user (VS Code convention)
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash sudo ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd -s /bin/bash --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
 && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-vscode \
 && chmod 0440 /etc/sudoers.d/99-vscode

# Create the virtual environment and ensure auto-activation for all bash shells
WORKDIR /workspace
RUN python3 -m venv "${VIRTUAL_ENV}" \
 && echo "source ${VIRTUAL_ENV}/bin/activate" >> /etc/bash.bashrc

# Default to the non-root user and workspace
USER ${USERNAME}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
WORKDIR /workspace
