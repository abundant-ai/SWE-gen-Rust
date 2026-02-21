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
RUN git clone https://github.com/hyperium/hyper.git src && \
    cd src && \
    (git fetch --depth 1 origin aac250f29d3b05d8c07681a407825811ec6a0b56 || git fetch --depth 1 origin "+refs/pull/1489/head:refs/remotes/origin/pr/1489") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV RUST_BACKTRACE=1

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix yanked spmc dependency by converting to git tag
RUN sed -i 's|spmc = "0.2"|spmc = { git = "https://github.com/seanmonstar/spmc", tag = "v0.2.2" }|' Cargo.toml

# Fetch dependencies
RUN cargo fetch

RUN rm -rf /app/src/.git

WORKDIR /app/src
