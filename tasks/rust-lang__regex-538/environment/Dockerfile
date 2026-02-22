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
RUN git clone https://github.com/rust-lang/regex.git src && \
    cd src && \
    (git fetch --depth 1 origin 6b33bf598860e56e62a70f8d0e2fd0f8fa19bf74 || git fetch --depth 1 origin "+refs/pull/538/head:refs/remotes/origin/pr/538") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Install dependencies
RUN cargo fetch

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix compilation error in replace.rs (pre-existing issue at this commit)
# Comment out the problematic closure_returning_reference test (lines 37-38)
RUN sed -i '37,38s/^/\/\/ /' tests/replace.rs

RUN rm -rf /app/src/.git

WORKDIR /app/src
