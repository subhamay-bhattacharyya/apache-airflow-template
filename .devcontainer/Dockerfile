# Dev Container: Python 3.12 + airflow-venv (auto-activated)
FROM python:3.12-slim

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    REPO_NAME=apache-airflow-template \
    WORKSPACE_DIR=/workspaces/${REPO_NAME} \
    VIRTUAL_ENV=/workspaces/${REPO_NAME}/airflow-venv \
    PATH="/workspaces/${REPO_NAME}/airflow-venv/bin:$PATH"

# --------------------------------------------------------------------
# Install minimal tools and create non-root user
# --------------------------------------------------------------------
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

# --------------------------------------------------------------------
# Create repo workspace directory and virtual environment
# --------------------------------------------------------------------
RUN mkdir -p ${WORKSPACE_DIR}
WORKDIR ${WORKSPACE_DIR}

RUN python3 -m venv "${VIRTUAL_ENV}" \
 && echo "source ${VIRTUAL_ENV}/bin/activate" >> /etc/bash.bashrc

# --------------------------------------------------------------------
# Default user and working directory
# --------------------------------------------------------------------
USER ${USERNAME}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
WORKDIR ${WORKSPACE_DIR}
