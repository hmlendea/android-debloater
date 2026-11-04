# Application Services Component

The application services component comprises the package probe and mutation helper functions that encapsulate all interactions with the Android package manager.

## Responsibilities

- Package state queries (installed, disabled)
- Package mutations (enable, disable, uninstall, reinstall, install)
- Predicate checks to skip unnecessary operations

## Implementation

Located in `android-debloater.sh`, lines 23–86.

### Probe Functions

```bash
function is_android_package_installed {
    local PACKAGE_NAME="${1}"
    adb shell pm list packages --user 0 | sed -e 's/^package://g' -e 's/[^a-zA-Z0-9.-]//g' | grep -q "^${PACKAGE_NAME}$" && return 0
    return 1
}

function is_android_package_disabled {
    local PACKAGE_NAME="${1}"
    ! is_android_package_installed "${PACKAGE_NAME}" && return 0
    adb shell pm list packages --user 0 -d | sed -e 's/^package://g' -e 's/[^a-zA-Z0-9.-]//g' | grep -q "^${PACKAGE_NAME}$" && return 0
    return 1
}
```

**Behaviour:**
- Both shell out to `adb shell pm list packages` each call (no caching)
- `is_android_package_disabled` returns true (0) if package is absent OR disabled
- Output sanitised via `sed` to remove `package:` prefix and non-alphanumeric chars

### Mutation Functions

```bash
function enable_android_package {
    for PACKAGE_NAME in "${@}"; do
        is_android_package_disabled "${PACKAGE_NAME}" || continue
        echo -e "Enabling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
        adb shell pm enable --user 0 "${PACKAGE_NAME}"
    done
}

function disable_android_package {
    for PACKAGE_NAME in "${@}"; do
        is_android_package_disabled "${PACKAGE_NAME}" && continue
        echo -e "Disabling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
        adb shell pm disable-user --user 0 "${PACKAGE_NAME}"
    done
}

function install_android_package {
    local PACKAGE_NAME="${1}"
    local PACKAGE_URL="${2}"
    local PACKAGE_FILE="${PACKAGE_NAME}.apk"
    is_android_package_installed "${PACKAGE_NAME}" && return
    echo -e "Installing Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
    wget --continue "${PACKAGE_URL}" -O "${PACKAGE_FILE}"
    adb install --user 0 "${PACKAGE_FILE}"
    rm "${PACKAGE_FILE}"
}

function uninstall_android_package {
    for PACKAGE_NAME in "${@}"; do
        ! is_android_package_installed "${PACKAGE_NAME}" && continue
        is_android_package_disabled "${PACKAGE_NAME}" && continue
        echo -e "Uninstalling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
        adb shell pm uninstall --user 0 "${PACKAGE_NAME}"
    done
}

function reinstall_android_package {
    local PACKAGE_NAME="${1}"
    is_android_package_installed "${PACKAGE_NAME}" && return
    echo -e "Reinstalling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
    adb shell pm install-existing --user 0 "${PACKAGE_NAME}"
}
```

**Behaviour:**
- All mutations target `--user 0` exclusively
- `enable_android_package`: skips if not disabled; enables via `pm enable`
- `disable_android_package`: skips if already disabled; disables via `pm disable-user`
- `install_android_package`: skips if installed; downloads APK, installs, removes temp file
- `uninstall_android_package`: skips if not installed OR already disabled; uninstalls via `pm uninstall`
- `reinstall_android_package`: skips if installed; reinstalls system package via `pm install-existing`

## Data Flow

```
Caller (catalogue) → Helper Function → ADB Command → Device Package Manager
                                      ↓
                              stdout/stderr → Console
                                      ↓
                              Return code → Caller (ignored)
```

## Error Handling

- No explicit error handling in helpers
- ADB command failures print to stderr but do not stop execution
- Return codes from ADB not checked; script continues to next package
- `wget` failures cause `adb install` to fail; temp file still removed

## Invariants

1. All package operations target `--user 0`
2. Probe functions re-query device state each call (no caching)
3. Mutations are idempotent-ish: skip if predicate already satisfied
4. Temporary APK files always removed after install attempt