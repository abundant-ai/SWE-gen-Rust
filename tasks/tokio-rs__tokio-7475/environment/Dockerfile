FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    strace \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tokio-rs/tokio.git src && \
    cd src && \
    (git fetch --depth 1 origin 61c14bbfd755e58aded6a4517cb4f7397ff09924 || git fetch --depth 1 origin "+refs/pull/7475/head:refs/remotes/origin/pr/7475") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables
ENV RUSTFLAGS="-Dwarnings"
ENV RUST_BACKTRACE=1

# Fetch dependencies for the entire workspace
RUN cargo fetch

# Build the workspace to ensure everything compiles
RUN cargo build --workspace --features full

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch
RUN cargo build --workspace --features full

RUN rm -rf /app/src/.git

WORKDIR /app/src
