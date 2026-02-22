FROM ubuntu:24.04

# Install base system packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rayon-rs/rayon.git src && \
    cd src && \
    (git fetch --depth 1 origin 4d2f0b62aeff9e1cd4116be36eb7f0d89553f3a1 || git fetch --depth 1 origin "+refs/pull/831/head:refs/remotes/origin/pr/831") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Install dependencies
RUN cargo fetch

# Build the project
RUN cargo build --verbose

# Reset tracked files so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch
RUN cargo build --verbose

RUN rm -rf /app/src/.git

WORKDIR /app/src
