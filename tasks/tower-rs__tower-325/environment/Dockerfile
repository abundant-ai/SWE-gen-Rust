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

# Allow warnings since this is an old codebase with modern Rust
ENV RUSTFLAGS="--cap-lints warn"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tower-rs/tower.git src && \
    cd src && \
    (git fetch --depth 1 origin b5f4777104353473d17deedfd256c87183ffa1cb || git fetch --depth 1 origin "+refs/pull/325/head:refs/remotes/origin/pr/325") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Fetch dependencies
RUN cargo fetch

# Build only tower-load-shed package (the package with our test)
RUN cargo build -p tower-load-shed --all-features

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN rm -rf /app/src/.git

WORKDIR /app/src
