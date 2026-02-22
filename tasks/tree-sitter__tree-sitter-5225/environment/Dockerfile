FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    libclang-dev \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (needed for web binding tests)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Rust (needed to build WASM bindings)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Emscripten 4.0.15 (needed for WASM build)
RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git /opt/emsdk && \
    cd /opt/emsdk && \
    ./emsdk install 4.0.15 && \
    ./emsdk activate 4.0.15
ENV EMSDK="/opt/emsdk"
ENV EM_CONFIG="/opt/emsdk/.emscripten"
ENV PATH="/opt/emsdk:/opt/emsdk/upstream/emscripten:${PATH}"

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/tree-sitter/tree-sitter.git src && \
    cd src && \
    (git fetch --depth 1 origin 07135e7bcd2f458fe9f74d7069c0b2ad0a1c42b2 || git fetch --depth 1 origin "+refs/pull/5225/head:refs/remotes/origin/pr/5225") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

ENV CARGO_TERM_COLOR=never

# Fetch Rust dependencies and build the project
RUN cargo fetch
RUN cargo build --release

# Fetch test grammars and generate WASM fixtures for testing
RUN cargo xtask fetch-fixtures
RUN cargo xtask generate-fixtures --wasm

# Install Node.js dependencies for web bindings
WORKDIR /app/src/lib/binding_web
RUN npm ci

# Build the web bindings (includes WASM build)
RUN npm run build

WORKDIR /app/src

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# Rebuild after applying bug.patch (required for TypeScript/WASM)
WORKDIR /app/src/lib/binding_web
RUN npm run build
WORKDIR /app/src

RUN rm -rf /app/src/.git

WORKDIR /app/src
