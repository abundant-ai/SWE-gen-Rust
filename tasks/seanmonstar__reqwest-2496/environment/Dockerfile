FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

# Install additional packages needed for Rust compilation
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Cargo is installed with Rust, no additional package manager setup needed

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/seanmonstar/reqwest.git src && \
    cd src && \
    (git fetch --depth 1 origin 21d9f27039bfb2c71b838fef6e0793a5272da423 || git fetch --depth 1 origin "+refs/pull/2496/head:refs/remotes/origin/pr/2496") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables for testing
ENV REQWEST_TEST_BODY_FULL=1
ENV RUST_BACKTRACE=1
ENV CARGO_INCREMENTAL=0
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

# Install dependencies
RUN cargo fetch

# Build the project
RUN cargo build

# Reset any files modified during build so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch
RUN cargo build

RUN rm -rf /app/src/.git

WORKDIR /app/src
