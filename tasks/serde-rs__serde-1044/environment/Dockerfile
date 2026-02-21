FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (nightly-2023-12-01 to avoid non-local impl definition errors)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly-2023-12-01 --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/serde-rs/serde.git src && \
    cd src && \
    (git fetch --depth 1 origin e9b530a000442052c5d7e1dbaa74cbc833376d30 || git fetch --depth 1 origin "+refs/pull/1044/head:refs/remotes/origin/pr/1044") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Reset tracked files to ensure bug.patch applies cleanly
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Fix unused import error caused by bug.patch (slice import becomes unused after patch)
RUN sed -i '149s/, slice//' serde/src/lib.rs

# Fix test_gen.rs - remove deny(warnings) line that causes issues with newer Rust nightlies
RUN sed -i '/^#!\[deny(warnings)\]/d' test_suite/tests/test_gen.rs

RUN rm -rf /app/src/.git

WORKDIR /app/src
