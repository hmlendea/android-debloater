# Logging

Android Debloater has **no structured logging framework**. Observability is limited to human-readable console output.

## Current Logging Approach

| Aspect | Implementation |
|--------|----------------|
| Framework | None (plain `echo` and command passthrough) |
| Levels | None (no Debug/Info/Warning/Error distinction) |
| Format | Plain text with ANSI colour codes |
| Structured fields | None (no request ID, correlation ID, timestamps) |
| Correlation | None (no trace IDs, span IDs) |
| Sinks | Stdout/stderr only (terminal) |
| Redaction | None (package names printed in clear) |
| Retention | None (terminal scrollback only) |
| Sampling | N/A |
| Performance | Synchronous, blocking |

## Console Output Examples

```bash
# Bootstrap failure
No ADB devices found!

# Package operations (yellow package names)
Disabling Android package: 'com.google.android.youtube'...
Installing Android package: 'com.aurora.store'...

# ADB/wget passthrough (stdout/stderr)
Success
Performing Streamed Install
Success
```

## Output Characteristics

- **No timestamps** — Cannot correlate events temporally
- **No log levels** — Cannot filter by severity
- **No structured fields** — Cannot parse programmatically
- **No correlation IDs** — Cannot trace across components
- **ANSI colour codes** — Yellow (`\e[0;33m`) for package names; reset (`\e[0m`)
- **Interleaved** — Script messages mixed with ADB/wget output

## What Is Logged

| Event | Logged? | Format |
|-------|---------|--------|
| Script start | No | — |
| Device detection | Implicit (via failure message) | "No ADB devices found!" |
| Device classification | No | — |
| Package probe | No | — |
| Package disable | Yes | "Disabling Android package: 'name'..." |
| Package enable | Yes | "Enabling Android package: 'name'..." |
| Package uninstall | Yes | "Uninstalling Android package: 'name'..." |
| Package install | Yes | "Installing Android package: 'name'..." |
| Package reinstall | Yes | "Reinstalling Android package: 'name'..." |
| APK download | Implicit (wget output) | wget progress/errors |
| ADB command result | Implicit (ADB output) | ADB stdout/stderr |
| Script end | No | — |

## What Is NOT Logged

- Timestamps for any operation
- Device serial number
- Operation duration
- Success/failure summary counts
- Skipped packages (already disabled/absent)
- SIM heuristic decision
- Final reconciliation

## Recommended Logging Improvements

| Improvement | Rationale |
|-------------|-----------|
| Add `set -o pipefail` and timestamp prefix | Basic temporal correlation |
| Add `--verbose`/`--quiet` flags | Verbosity control |
| Add `--log-file` option | Persistent log sink |
| Add structured JSON output option | Machine readability |
| Add correlation ID per invocation | Traceability |
| Add final summary report | Reconciliation |
| Add log levels (INFO/WARN/ERROR) | Filtering |
| Redact sensitive data (if any) | Security hygiene |

## Security Considerations

- Package names are not sensitive but reveal device software inventory
- No credentials, tokens, or personal data in output
- ADB output may contain device-specific paths or identifiers
- Operator should be aware console output visible in terminal history