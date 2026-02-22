FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust with wasm32 target
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup target add wasm32-unknown-unknown

# Install additional packages for Rust compilation
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/seanmonstar/reqwest.git src && \
    cd src && \
    (git fetch --depth 1 origin 3ee01c4fa0b702a907b620ff4fb866f1c0ba6ee5 || git fetch --depth 1 origin "+refs/pull/651/head:refs/remotes/origin/pr/651") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV REQWEST_TEST_BODY_FULL=1
ENV RUST_BACKTRACE=1
ENV CARGO_INCREMENTAL=0
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

# Fix broken Cargo.toml at HEAD (empty wasm-bindgen-futures version and non-existent feature)
RUN sed -i 's/wasm-bindgen-futures = { version = "", features = \["futures_0_3"\] }/wasm-bindgen-futures = "0.4.18"/g' Cargo.toml

# Remove rust-toolchain file to use the default stable toolchain we installed
RUN rm -f rust-toolchain

RUN cargo fetch

RUN cargo build

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix broken Cargo.toml again after reset/patch
RUN sed -i 's/wasm-bindgen-futures = { version = "", features = \["futures_0_3"\] }/wasm-bindgen-futures = "0.4.18"/g' Cargo.toml

# Remove rust-toolchain file again after reset
RUN rm -f rust-toolchain

# Rebuild after applying bug.patch
RUN cargo build

RUN rm -rf /app/src/.git

WORKDIR /app/src
