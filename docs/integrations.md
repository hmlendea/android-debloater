# Integrations

External system integrations and their contracts.

## ADB (Android Debug Bridge)

### Role
Primary transport for all device operations.

### Contract
| Aspect | Detail |
|--------|--------|
| Protocol | ADB wire protocol over USB/TCP |
| Authentication | Device-side RSA key authorisation |
| Commands | `adb devices`, `adb shell pm ...` |
| User targeting | `--user 0` on all `pm` calls |
| Output format | `pm list packages` → `package:<id>` lines |

### Failure Modes
| Condition | Behaviour |
|-----------|-----------|
| No device | `adb devices` returns only header → script exits |
| Multiple devices | First device used (no `-s` support) |
| Unauthorised | `adb devices` shows "unauthorized" → commands fail |
| Device disconnect mid-run | Subsequent commands fail silently |

### Version Compatibility
- ADB client: Any recent version (platform-tools ≥ 30)
- ADB server: Matches client
- Android device: API 21+ (Android 5.0+) for `disable-user`

## HTTPS APK Providers

### Providers Used

| Provider | Packages | URL Pattern |
|----------|----------|-------------|
| Aurora Store | `com.aurora.store` | `https://gitlab.com/AuroraOSS/AuroraStore/-/jobs/artifacts/master/raw/app/build/outputs/apk/release/app-release.apk?job=build` |
| F-Droid | `org.fdroid.fdroid` | `https://f-droid.org/FDroid.apk` |
| Fossify | Multiple | `https://github.com/FossifyOrg/<App>/releases/download/<version>/<app>-<version>.apk` |
| Breezy Weather | `com.breezyweather` | `https://github.com/breezy-weather/breezy-weather/releases/download/<version>/breezy-weather-<version>.apk` |

### Contract
| Aspect | Detail |
|--------|--------|
| Protocol | HTTPS (TLS 1.2+) |
| Method | `GET` via `wget --continue` |
| Output | Binary APK to `${PACKAGE_NAME}.apk` |
| Verification | None (Android verifies on install) |
| Redirects | Followed by `wget` |

### Failure Modes
| Condition | Behaviour |
|-----------|-----------|
| Network unreachable | `wget` fails → install skipped silently |
| HTTP error (404, 5xx) | `wget` fails → install skipped silently |
| TLS error | `wget` fails → install skipped silently |
| Partial download | `--continue` resumes on re-run |
| Wrong APK | Android rejects on install (signature mismatch) |

## Host Filesystem

### Contract
| Aspect | Detail |
|--------|--------|
| Working directory | Script execution directory |
| Temporary files | `${PACKAGE_NAME}.apk` created during provisioning |
| Cleanup | `rm -f "${PACKAGE_FILE}"` after each install attempt |
| Permissions | Operator user write access required |

### Failure Modes
| Condition | Behaviour |
|-----------|-----------|
| No write permission | `wget` fails → install skipped |
| Disk full | `wget` fails → install skipped |
| File collision | Overwrites (single-threaded) |

## GitHub Actions (CI)

### Contract
| Aspect | Detail |
|--------|--------|
| Trigger | Push/PR to any branch |
| Runner | `ubuntu-latest` |
| Tool | ShellCheck (system package) |
| Scope | All `**/*.sh` files |
| Severity | `--severity error` only |

### Workflow File
`.github/workflows/bash.yml`

```yaml
name: Bash
on: [push, pull_request]
jobs:
  shellcheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run ShellCheck
        run: |
          shopt -s globstar nullglob
          shellcheck **/*.sh --severity error
```

### Failure Modes
| Condition | Behaviour |
|-----------|-----------|
| ShellCheck error | Job fails (red) |
| ShellCheck warning | Job passes (warnings ignored) |
| No `.sh` files | `globstar` expands to nothing → ShellCheck exits 0 |

## Integration Summary Matrix

| Integration | Direction | Auth | Encryption | Verification | Retry |
|-------------|-----------|------|------------|--------------|-------|
| ADB | Bidirectional | Device RSA | No (USB) / Optional (TCP) | None | No |
| HTTPS APK | Outbound | TLS | Yes (TLS) | None | `wget --continue` |
| Host FS | Outbound | OS perms | N/A | N/A | No |
| GitHub Actions | Inbound (webhook) | GitHub | HTTPS | ShellCheck | N/A |