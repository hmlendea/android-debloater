# Error Handling

## Current Error Handling Approach

The script uses **implicit, best-effort error handling** with minimal explicit guards.

### Explicit Guards

| Guard | Location | Behaviour |
|-------|----------|-----------|
| No devices | Lines 16–21 | Print message, `exit 1` |

### Implicit Handling (All Other Operations)

| Operation | Failure Mode | Script Behaviour |
|-----------|--------------|------------------|
| `adb devices` | Command not found, daemon down | Empty output → treated as no devices → exit 1 |
| `adb shell pm list packages` | Device disconnected, permission denied | `grep` fails → probe returns 1 → mutation skipped or attempted |
| `adb shell pm disable-user` | Package protected, not found, permission denied | Error to stderr → script continues |
| `adb shell pm uninstall` | System package, not found, permission denied | Error to stderr → script continues |
| `adb shell pm enable` | Package not disabled, not found | Error to stderr → script continues |
| `adb shell pm install-existing` | Package not in system image | Error to stderr → script continues |
| `wget` | Network error, 404, timeout | Error to stderr → `adb install` fails → `rm` executes |
| `adb install` | Signature mismatch, version downgrade, space full | Error to stderr → `rm` executes → script continues |
| `rm` | Permission denied, file missing | Error to stderr (rare) → script continues |

## Error Handling Gaps

| Gap | Impact | Mitigation |
|-----|--------|------------|
| No `set -euo pipefail` | Unset variables, pipeline failures silent | Add at script top |
| No error aggregation | Failures lost in output | Collect errors in array, report at end |
| No retry logic | Transient network/ADB failures cause skips | Implement retry with backoff |
| No rollback | Partial failure leaves inconsistent state | Transaction log + compensation (complex) |
| No dry-run | Cannot preview changes | Add `--dry-run` flag |
| No device targeting | Multi-device ambiguity | Add `-s <serial>` threading |

## Error Taxonomy

| Category | Examples | Current Handling |
|----------|----------|------------------|
| Precondition failure | No ADB devices | Explicit exit 1 |
| Tool missing | `adb`, `wget` not in PATH | Command not found → implicit failure |
| Network failure | `wget` timeout, DNS, 404 | Implicit; download fails → install fails |
| Device communication | ADB disconnect, unauthorised | Implicit; subsequent commands fail |
| Package operation | Protected package, not found, permission | Implicit; error printed, continue |
| Filesystem | CWD not writable, disk full | Implicit; `wget`/`rm` fail |

## Recommended Improvements

1. **Add `set -euo pipefail`** at script start (after shebang)
2. **Implement error collection** array to track failures
3. **Add `--dry-run` flag** to preview operations without executing
4. **Add `--device <serial>` flag** for multi-device support
5. **Add final summary** reporting: disabled, uninstalled, installed, skipped, failed counts
6. **Add APK checksum verification** before install
7. **Add timeout** for ADB and wget commands