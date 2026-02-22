FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (minimum version 1.88.0 required)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Node.js 22 for browser-ui-test
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/rust-lang/mdBook.git src && \
    cd src && \
    (git fetch --depth 1 origin 58af25384dc4790296a34fee6979c57b29257782 || git fetch --depth 1 origin "+refs/pull/2898/head:refs/remotes/origin/pr/2898") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# Install npm dependencies (browser-ui-test for GUI testing)
RUN npm install

# Fetch Rust dependencies
RUN cargo fetch --locked

# Build mdbook and all workspace crates
RUN cargo build --workspace --locked

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch to incorporate the reverted changes
# The bug.patch modifies CSS, JS templates, AND the test file
# We need to rebuild so the templates/CSS are embedded in the binary
# Touch the source files to force cargo to rebuild
RUN touch crates/mdbook-html/src/theme/mod.rs
RUN cargo build --workspace --locked

RUN rm -rf /app/src/.git

WORKDIR /app/src
