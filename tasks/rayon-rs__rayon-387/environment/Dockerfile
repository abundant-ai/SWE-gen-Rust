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
    (git fetch --depth 1 origin aace5bd6577935f78781fb4b855e7006c4fc5c74 || git fetch --depth 1 origin "+refs/pull/387/head:refs/remotes/origin/pr/387") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Remove rayon-demo from workspace (has yanked dependencies)
RUN sed -i 's/members = \["rayon-demo", "rayon-core"\]/members = ["rayon-core"]/' Cargo.toml

# Install dependencies
RUN cargo fetch

# Reset tracked files so bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Remove rayon-demo from workspace permanently (has yanked dependencies) - do it again after patch
RUN sed -i 's/members = \["rayon-demo", "rayon-core"\]/members = ["rayon-core"]/' Cargo.toml
RUN rm -rf rayon-demo

# Remove compiletest_rs from dev-dependencies to avoid build issues with modern nightly
RUN sed -i '/compiletest_rs/d' Cargo.toml

# Remove src/test.rs which depends on compiletest_rs, and comment out the mod declaration
RUN rm -f src/test.rs && sed -i 's/^mod test;/\/\/ mod test;/' src/lib.rs

RUN rm -rf /app/src/.git

WORKDIR /app/src
