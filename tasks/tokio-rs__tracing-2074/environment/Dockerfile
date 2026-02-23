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
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tokio-rs/tracing.git src && \
    cd src && \
    (git fetch --depth 1 origin 6d68aab03817faf880bcfc5146c98cc4112cc14e || git fetch --depth 1 origin "+refs/pull/2074/head:refs/remotes/origin/pr/2074") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV CARGO_INCREMENTAL=0
ENV RUST_BACKTRACE=short

RUN cargo fetch
RUN cargo build -p tracing --tests

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN cargo build -p tracing --tests

RUN rm -rf /app/src/.git

WORKDIR /app/src
