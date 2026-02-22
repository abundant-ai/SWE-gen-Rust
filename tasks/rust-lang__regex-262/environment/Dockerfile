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

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rust-lang/regex.git src && \
    cd src && \
    (git fetch --depth 1 origin 84a2bf5d73e52e961f41e312e449dd251f86e34d || git fetch --depth 1 origin "+refs/pull/262/head:refs/remotes/origin/pr/262") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Install dependencies
RUN cargo fetch

RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

RUN rm -rf /app/src/.git

WORKDIR /app/src
