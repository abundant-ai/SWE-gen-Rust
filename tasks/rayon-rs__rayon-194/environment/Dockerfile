FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (nightly for older code with feature flags)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUSTFLAGS="-A warnings -A let_underscore_lock"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rayon-rs/rayon.git src && \
    cd src && \
    (git fetch --depth 1 origin cb23bfaf1412b67ccedcd904904a93a7f3358f30 || git fetch --depth 1 origin "+refs/pull/194/head:refs/remotes/origin/pr/194") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Remove rayon-demo from workspace (has yanked dependencies)
RUN sed -i 's/members = \[ "rayon-demo" \]/members = []/' Cargo.toml && \
    rm -rf rayon-demo

# Install dependencies
RUN cargo fetch

# Reset tracked files so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Bug patch renames src/slice/mod.rs to src/slice.rs, but patch tool doesn't always delete the old directory
# Remove the slice directory to avoid module ambiguity error (E0761)
RUN rm -rf src/slice/

# Remove rayon-demo from workspace permanently (has yanked dependencies) - do it again after patch
RUN sed -i 's/members = \[ "rayon-demo" \]/members = []/' Cargo.toml && \
    rm -rf rayon-demo

RUN rm -rf /app/src/.git

WORKDIR /app/src
