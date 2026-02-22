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
    (git fetch --depth 1 origin 24b6270b93ce79bf07f0a14198d24d8a495f4347 || git fetch --depth 1 origin "+refs/pull/2106/head:refs/remotes/origin/pr/2106") && \
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

# Build the project (HEAD state)
RUN cargo build

# Reset tracked files before applying bug.patch
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (BASE state)
RUN cargo build

RUN rm -rf /app/src/.git

WORKDIR /app/src
