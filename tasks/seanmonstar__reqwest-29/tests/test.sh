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

# Copy HEAD test files from /tests (overwrites BASE state)
mkdir -p "tests"
cp "/tests/client.rs" "tests/client.rs"

# Run the specific test file for this PR
# In BASE state: RedirectPolicy code is missing, so tests using it won't compile
# In FIXED state: RedirectPolicy code exists, tests compile and run
output=$(cargo test --test client -- --nocapture 2>&1)
test_status=$?

# Check that the RedirectPolicy tests ran
# We expect test_redirect_policy_* to be present in the output if the fix is applied
if echo "$output" | grep -q "test test_redirect_policy"; then
  # Success - the RedirectPolicy tests are present and ran, meaning the fix is applied
  echo 1 > /logs/verifier/reward.txt
  exit_code=0
else
  # Failure - RedirectPolicy tests missing or didn't compile, meaning we're in BASE state
  echo 0 > /logs/verifier/reward.txt
  exit_code=1
fi

echo "$output"
exit "$exit_code"
