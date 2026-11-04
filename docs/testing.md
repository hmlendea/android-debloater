# Testing

## Current Test Strategy

The repository has **no automated device-level test suite**. Testing relies on:

1. **Static analysis** — ShellCheck via GitHub Actions (CI)
2. **Manual execution** — Operator runs script against physical device
3. **Manual verification** — Operator confirms expected package state changes

## Test Organisation

| Test Type | Framework | Location | Coverage |
|-----------|-----------|----------|----------|
| Static analysis | ShellCheck | `.github/workflows/bash.yml` | All `**/*.sh` |
| Unit tests | None | N/A | N/A |
| Integration tests | None | N/A | N/A |
| Device simulation | None | N/A | N/A |
| Contract tests | None | N/A | N/A |

## ShellCheck Validation

```bash
# Local reproduction
shopt -s globstar nullglob
shellcheck **/*.sh --severity error
```

**Scope**: Syntax errors, quoting issues, unused variables, deprecated constructs
**Severity**: `error` only (warnings ignored in CI)

## Manual Testing Procedure

### Prerequisites

1. Android device with USB debugging enabled
2. ADB authorised on device
3. Host with `bash`, `adb`, `wget`

### Test Scenarios

| Scenario | Steps | Expected |
|----------|-------|----------|
| No device | Run without device connected | "No ADB devices found!" + exit 1 |
| Phone detection | Connect phone, run script | DEVICE_TYPE='Phone', provisioning runs |
| TV detection | Connect Android TV, run script | DEVICE_TYPE='TV', no provisioning |
| Disable packages | Run on phone with bloatware | Packages disabled, console shows each |
| Uninstall packages | Run on phone with uninstall targets | Packages uninstalled, console shows each |
| Recovery enable | `adb shell pm enable --user 0 <pkg>` | Package re-enabled |
| Recovery reinstall | `adb shell pm install-existing --user 0 <pkg>` | System package restored |

### Verification Commands

```bash
# List disabled packages
adb shell pm list packages --user 0 -d

# List all packages
adb shell pm list packages --user 0

# Check specific package
adb shell pm list packages --user 0 | grep <package.name>
```

## Test Gaps

| Gap | Risk | Mitigation |
|-----|------|------------|
| No automated device tests | Regressions undetected | Add device farm CI (complex) |
| No unit tests for helpers | Logic errors in probes/mutations | Extract helpers to testable library |
| No dry-run testing | Cannot validate catalogue safely | Implement `--dry-run` |
| No multi-device testing | Single-target assumption untested | Document limitation |
| No OEM/ROM matrix testing | Package relevance varies | Community reporting |

## Recommended Test Improvements

1. **Extract helper functions** to separate library file for unit testing
2. **Add BATS (Bash Automated Testing System)** for unit tests
3. **Implement `--dry-run` mode** for safe catalogue validation
4. **Add device simulation** using mocked ADB responses
5. **Create test fixtures** for package listing outputs
6. **Add regression tests** for known problem packages