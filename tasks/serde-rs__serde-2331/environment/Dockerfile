FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust with nightly from around the PR date (Nov 2023)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly-2024-12-20
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/serde-rs/serde.git src && \
    cd src && \
    (git fetch --depth 1 origin 50354c2d0bb623ff6bb57ba573c6ef3fd4180df6 || git fetch --depth 1 origin "+refs/pull/2331/head:refs/remotes/origin/pr/2331") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Reset tracked files to ensure bug.patch applies cleanly
RUN git reset --hard

# Fix unused imports issue that exists in this commit but was fixed later
RUN sed -i 's/pub use self::core::{cmp, iter, mem, num, ptr, slice, str};/pub use self::core::{cmp, iter, num, ptr, slice, str};/' serde/src/lib.rs

# Lock dependencies to compatible versions
RUN cd test_suite && \
    cargo update home --precise 0.5.11

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Remove all other UI test stderr files to avoid version-related failures
# Keep only the test files that will be copied from /tests
RUN find test_suite/tests/ui -name "*.stderr" -delete && \
    find test_suite/tests/ui -name "*.rs" -delete

RUN rm -rf /app/src/.git

WORKDIR /app/src
