#!/bin/bash

cd /app/src

# Set up Rust environment
export PATH="/root/.cargo/bin:${PATH}"
export RUSTFLAGS="--cap-lints=warn"

# Fix yanked dependency
sed -i 's/native-tls = "0.1"/native-tls = "=0.2.7"/' Cargo.toml

# Fix native-tls 0.2 API in tls.rs
cat > src/tls.rs <<'EOFTLS'
use std::io::{self, Read, Write};
use std::net::SocketAddr;
use std::time::Duration;
use std::fmt;

use hyper::net::{SslClient, HttpStream, NetworkStream};
use native_tls::{TlsConnector, TlsStream as NativeTlsStream};

pub struct TlsClient(TlsConnector);

impl TlsClient {
    pub fn new() -> ::Result<TlsClient> {
        TlsConnector::new()
            .map(TlsClient)
            .map_err(|e| ::Error::Http(::hyper::Error::Ssl(Box::new(e))))
    }
}

impl SslClient for TlsClient {
    type Stream = TlsStream;

    fn wrap_client(&self, stream: HttpStream, host: &str) -> ::hyper::Result<Self::Stream> {
        self.0.connect(host, stream).map(TlsStream).map_err(|e| {
            ::hyper::Error::Ssl(Box::new(e))
        })
    }
}

impl fmt::Debug for TlsClient {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.debug_tuple("TlsClient").field(&"_").finish()
    }
}

#[derive(Debug)]
pub struct TlsStream(NativeTlsStream<HttpStream>);

impl Read for TlsStream {
    fn read(&mut self, buf: &mut [u8]) -> io::Result<usize> {
        self.0.read(buf)
    }
}

impl Write for TlsStream {
    fn write(&mut self, data: &[u8]) -> io::Result<usize> {
        self.0.write(data)
    }

    fn flush(&mut self) -> io::Result<()> {
        self.0.flush()
    }
}

impl Clone for TlsStream {
    fn clone(&self) -> TlsStream {
        unreachable!("TlsStream::clone is never used for the Client")
    }
}

impl NetworkStream for TlsStream {
    fn peer_addr(&mut self) -> io::Result<SocketAddr> {
        self.0.get_mut().peer_addr()
    }

    fn set_read_timeout(&self, dur: Option<Duration>) -> io::Result<()> {
        self.0.get_ref().set_read_timeout(dur)
    }

    fn set_write_timeout(&self, dur: Option<Duration>) -> io::Result<()> {
        self.0.get_ref().set_write_timeout(dur)
    }
}
EOFTLS

# Copy HEAD test files from /tests
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"

# Run tests - they pass only if can_reset() function exists (FIXED state)
# BASE state: 307/308 redirect tests fail because can_reset() is missing
# FIXED state: 307/308 redirect tests pass
output=$(cargo test --test client -- --nocapture 2>&1)
test_status=$?

if [ $test_status -eq 0 ]; then
  echo 1 > /logs/verifier/reward.txt
  exit_code=0
else
  echo 0 > /logs/verifier/reward.txt
  exit_code=0
fi

echo "$output"
exit "$exit_code"
