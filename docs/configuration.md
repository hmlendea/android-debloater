# Configuration

Android Debloater has **no external configuration files, environment variables, or command-line arguments**. All configuration is hard-coded in `android-debloater.sh`.

## Hard-Coded Configuration

### Device Classification Heuristic

```bash
if is_android_package_installed 'com.google.android.tv.remote.service'; then
    DEVICE_TYPE='TV'
else
    DEVICE_TYPE='Phone'
fi
```

- **Location**: Lines 88–91
- **Modification**: Change package name to alter classification logic

### Phone Provisioning APKs

```bash
install_android_package 'com.aurora.store' 'https://auroraoss.com/downloads/AuroraStore/Release/AuroraStore-4.6.2.apk'
install_android_package 'org.fdroid.fdroid' 'https://f-droid.org/F-Droid.apk'
# ... 12 more install_android_package calls
```

- **Location**: Lines 94–130
- **Modification**: Add/remove/edit `install_android_package` calls
- **SIM heuristic**: `com.android.stk` presence gates calling/messaging apps

### Debloat Package Catalogue

~300 package identifiers in `disable_android_package` and `uninstall_android_package` calls, grouped by vendor/category with comments.

- **Location**: Lines 133–662
- **Modification**: Add/remove package identifiers in appropriate groups

### ADB User Target

All package operations hard-code `--user 0`:

```bash
adb shell pm disable-user --user 0 "${PACKAGE_NAME}"
adb shell pm uninstall --user 0 "${PACKAGE_NAME}"
adb shell pm enable --user 0 "${PACKAGE_NAME}"
adb shell pm install-existing --user 0 "${PACKAGE_NAME}"
adb install --user 0 "${PACKAGE_FILE}"
```

- **Location**: Helper functions (lines 46–86)
- **Modification**: Change `--user 0` to target different user

### Temporary File Location

```bash
local PACKAGE_FILE="${PACKAGE_NAME}.apk"
# Written to current working directory
wget --continue "${PACKAGE_URL}" -O "${PACKAGE_FILE}"
# ...
rm "${PACKAGE_FILE}"
```

- **Location**: `install_android_package` function (lines 66–76)
- **Modification**: Change `PACKAGE_FILE` assignment to use different directory

## Configuration Precedence

Since no external configuration exists, precedence is not applicable. All behaviour is determined by source code.

## Runtime Overrides

Operators can modify behaviour by:

1. **Editing the script directly** — Primary method
2. **Setting aliases/wrappers** — e.g., `alias adb='adb -s <serial>'` for device targeting
3. **Environment manipulation** — `PATH` ordering for `adb`/`wget` selection

## Desired Configuration Improvements

| Improvement | Rationale |
|-------------|-----------|
| External package catalogue file | Decouple data from logic; enable versioned catalogues |
| Command-line flags (`--dry-run`, `--device`, `--user`) | Enable safe preview and multi-device support |
| Environment variable for APK directory | Avoid CWD pollution |
| Configuration file for URLs | Allow URL updates without source changes |
| Checksum file for APKs | Verify download integrity |