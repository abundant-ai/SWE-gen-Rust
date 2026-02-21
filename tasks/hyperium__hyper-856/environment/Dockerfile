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
    (git fetch --depth 1 origin 2904668105649e674aab7d0945a8f117a0dba32b || git fetch --depth 1 origin "+refs/pull/856/head:refs/remotes/origin/pr/856") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV RUST_BACKTRACE=1

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix yanked dependencies by converting to git tags
RUN sed -i 's|spmc = "0.2"|spmc = { git = "https://github.com/seanmonstar/spmc", tag = "v0.2.2" }|' Cargo.toml && \
    sed -i '/\[dependencies.security-framework\]/{ n; s|version = "0.1.4"|git = "https://github.com/kornelski/rust-security-framework"\ntag = "v0.1.12"|; }' Cargo.toml

# Fetch dependencies
RUN cargo fetch

RUN rm -rf /app/src/.git

WORKDIR /app/src
