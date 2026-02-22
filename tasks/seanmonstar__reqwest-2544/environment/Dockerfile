FROM ubuntu:24.04

# Install system packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/seanmonstar/reqwest.git src && \
    cd src && \
    (git fetch --depth 1 origin b567ee676137b8c8af1b657e5ece9aa8d7318613 || git fetch --depth 1 origin "+refs/pull/2544/head:refs/remotes/origin/pr/2544") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Set environment variables from CI config
ENV REQWEST_TEST_BODY_FULL=1
ENV RUST_BACKTRACE=1
ENV CARGO_INCREMENTAL=0
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse
ENV RUSTFLAGS='--cfg reqwest_unstable'
ENV RUSTDOCFLAGS='--cfg reqwest_unstable'

# Pin quinn ecosystem to 0.11.2 for compatibility with h3-quinn 0.0.7
# h3-quinn 0.0.7 requires StreamId.0 to be public, which was changed in newer versions
# We use 0.11.2 for all quinn crates to ensure compatibility
RUN cargo update -p quinn --precise 0.11.2 && \
    cargo update -p quinn-proto --precise 0.11.2 && \
    cargo update -p quinn-udp --precise 0.5.5

# Build with http3 feature to generate Cargo.lock
RUN cargo build --features http3 --release || true

# Reset source code to ensure bug.patch applies cleanly
RUN git reset --hard HEAD

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN rm -rf /app/src/.git

WORKDIR /app/src
