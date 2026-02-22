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

# Install additional packages for Rust compilation
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/seanmonstar/reqwest.git src && \
    cd src && \
    (git fetch --depth 1 origin eef1417bbb86d77e4cdb5d103d07ad48d632fec8 || git fetch --depth 1 origin "+refs/pull/2186/head:refs/remotes/origin/pr/2186") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables
ENV REQWEST_TEST_BODY_FULL=1
ENV RUST_BACKTRACE=1
ENV CARGO_INCREMENTAL=0
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

# Install dependencies
RUN cargo fetch

# Build the project with hickory-dns feature (HEAD state)
RUN cargo build --features hickory-dns

# Reset tracked files before applying bug.patch
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch with trust-dns feature (BASE state)
RUN cargo build --features trust-dns

RUN rm -rf /app/src/.git

WORKDIR /app/src
