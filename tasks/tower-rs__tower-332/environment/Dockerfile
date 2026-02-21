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
    (git fetch --depth 1 origin fe4f602d72990a76de3095e43a467133a60b6aa3 || git fetch --depth 1 origin "+refs/pull/332/head:refs/remotes/origin/pr/332") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Fetch dependencies
RUN cargo fetch

# Build only tower-spawn-ready package (the package with our test)
RUN cargo build -p tower-spawn-ready --all-features

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN rm -rf /app/src/.git

WORKDIR /app/src
