# Presentation Component

The presentation component is the console output produced by the script during execution. It is the only user-facing interface.

## Responsibilities

- Announce package operations (enable, disable, uninstall, install)
- Surface ADB and wget command output (stdout/stderr)
- Report bootstrap failure (no devices found)

## Implementation

Located in `android-debloater.sh` within helper functions:

```bash
echo -e "Enabling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
echo -e "Disabling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
echo -e "Installing Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
echo -e "Uninstalling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
echo -e "Reinstalling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
```

And bootstrap:
```bash
echo "No ADB devices found!"
```

## Output Characteristics

- **Format**: Plain text with ANSI colour codes (yellow for package names)
- **Structure**: One line per package operation, interleaved with subordinate command output
- **No structured logging**: No JSON, no log levels, no timestamps, no correlation IDs
- **No summary**: No final reconciliation of operations performed vs skipped vs failed

## Dependencies

- Terminal supporting ANSI escape codes (for colour)
- ADB and wget stdout/stderr passed through directly

## Limitations

- No verbosity control (no `--quiet`, `--verbose`)
- No machine-readable output format
- No progress indication for long operations (downloads, installs)
- No final report of changes made