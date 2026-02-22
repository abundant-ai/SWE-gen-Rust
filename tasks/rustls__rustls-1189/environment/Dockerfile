FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install additional system packages
RUN apt-get update && apt-get install -y \
    cmake \
    golang \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Install Rust with nightly toolchain (needed for read_buf feature)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rustls/rustls.git src && \
    cd src && \
    (git fetch --depth 1 origin 1c05144b55e9418f315a361dd88bceeb288a5e1d || git fetch --depth 1 origin "+refs/pull/1189/head:refs/remotes/origin/pr/1189") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set RUSTFLAGS to allow compilation despite dependency issues
ENV RUSTFLAGS="--cap-lints=warn"

# Patch the dependency issue: pin rustls-pki-types to 0.2.0 which is compatible with the alpha webpki
RUN sed -i 's/rustls-pki-types", version = "0.2.0"/rustls-pki-types", version = "=0.2.0"/' rustls/Cargo.toml

# Install dependencies (fetch crates)
RUN cargo fetch

# Reset to clean state so bug.patch applies cleanly
RUN git reset --hard

# Regenerate test certificates to avoid expiration issues (after reset so they persist)
RUN cd test-ca && ./build-a-pki.sh

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN rm -rf /app/src/.git

WORKDIR /app/src
