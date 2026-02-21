FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (use 1.70 to avoid mem::uninitialized panic in old tokio-sync crate)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.70.0
ENV PATH="/root/.cargo/bin:${PATH}"

# Allow warnings since this is an old codebase with modern Rust
ENV RUSTFLAGS="--cap-lints warn"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tower-rs/tower.git src && \
    cd src && \
    (git fetch --depth 1 origin 759e446fe366558c8543c5dbaf80805b63fbba09 || git fetch --depth 1 origin "+refs/pull/178/head:refs/remotes/origin/pr/178") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Fetch dependencies
RUN cargo fetch

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN rm -rf /app/src/.git

WORKDIR /app/src
