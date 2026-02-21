When generating help output for an option that has a default value, clap currently renders an empty string default as an empty token, producing confusing output like `[default: ]`. This happens for example with a derive-based parser when using an empty `String` default via `default_value_t`:

```rust
use clap::Parser;

#[derive(Parser)]
struct Opts {
    #[clap(long, default_value_t)]
    text: String,
}
```

Running the program with `--help` currently shows the option as:

```
--text <TEXT>  [default: ]
```

This should be rendered in an unambiguous way so users can tell the default is the empty string. Expected output is to quote the empty default value so it is visible, e.g.:

```
--text <TEXT>  [default: ""]
```

Only empty default values should be changed in this way; default values that contain whitespace should keep their existing help rendering behavior (do not introduce new quoting rules for them as part of this change). The change must apply to defaults coming from `default_value_t` (including `String`) and should be reflected consistently anywhere clap prints the default in help output.