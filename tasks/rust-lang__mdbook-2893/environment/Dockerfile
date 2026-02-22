FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (MSRV 1.88.0 from Cargo.toml)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.88.0
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Node.js 22 for GUI tests (browser-ui-test)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Chromium for GUI tests
# Ubuntu 24.04's chromium-browser package is a snap stub, so we need to install from chromium PPA
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rust-lang/mdBook.git src && \
    cd src && \
    (git fetch --depth 1 origin 5282083decf2e7c2c6c58fb4e6f163721d282275 || git fetch --depth 1 origin "+refs/pull/2893/head:refs/remotes/origin/pr/2893") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Fetch Rust dependencies
RUN cargo fetch --locked

# Build the project
RUN cargo build --workspace --locked

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Install npm dependencies for GUI tests (after git reset)
RUN npm install

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after patching (Rust is a compiled language)
RUN cargo build --workspace --locked

RUN rm -rf /app/src/.git

WORKDIR /app/src
