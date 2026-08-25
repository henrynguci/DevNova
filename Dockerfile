# Dockerfile - DevNova Enterprise Test Environment
FROM ubuntu:24.04

# Avoid interactive prompts during apt installation & set terminal
ENV DEBIAN_FRONTEND=noninteractive
ENV NON_INTERACTIVE=1
ENV TERM=xterm-256color
ENV GOINSECURE="*"
ENV GOPROXY="https://proxy.golang.org,direct"

# Configure APT to bypass SSL verification for corporate proxy / SSL inspection environments
RUN echo 'Acquire::https::Verify-Peer "false";' > /etc/apt/apt.conf.d/99ssl-insecure \
    && echo 'Acquire::https::Verify-Host "false";' >> /etc/apt/apt.conf.d/99ssl-insecure

# Install base build & system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    bash \
    ca-certificates \
    gnupg \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates || true

# Install Charm Gum TUI tool via APT (using -k for curl SSL proxy resilience)
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSLk https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" > /etc/apt/sources.list.d/charm.list \
    && apt-get update && apt-get install -y gum \
    && rm -rf /var/lib/apt/lists/*

# Install Go compiler (version 1.24.4)
RUN curl -fsSLk https://go.dev/dl/go1.24.4.linux-amd64.tar.gz -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Create non-root developer user with passwordless sudo (matches real desktop environment)
RUN useradd -m -s /bin/bash devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER devuser
WORKDIR /home/devuser/devnova

# Copy project source into container
COPY --chown=devuser:devuser . /home/devuser/devnova/

# Strip potential Windows CRLF line endings & pre-build Go helper binaries
RUN find . -type f -name "*.sh" -exec sed -i 's/\r$//' {} + && \
    sed -i 's/\r$//' devnova && \
    chmod +x build.sh install.sh devnova && \
    ./build.sh

# Default command
CMD ["./devnova", "--help"]
