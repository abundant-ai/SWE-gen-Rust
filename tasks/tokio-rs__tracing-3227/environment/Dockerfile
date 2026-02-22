FROM ubuntu:24.04

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

RUN git clone https://github.com/tokio-rs/tracing.git src && \
    cd src && \
    (git fetch --depth 1 origin f93578441be9e473fb807397afed00e2d4642f66 || git fetch --depth 1 origin "+refs/pull/3227/head:refs/remotes/origin/pr/3227") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV CARGO_INCREMENTAL=0
ENV RUST_BACKTRACE=short

RUN cargo fetch
RUN cargo build --workspace --tests

RUN git reset --hard

COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN cargo build --workspace --tests

RUN rm -rf /app/src/.git

WORKDIR /app/src
