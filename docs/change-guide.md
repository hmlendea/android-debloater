# Change Guide

This document describes how to safely modify common areas of Android Debloater.

## Adding a Package to the Debloat Catalogue

### Disable (Preferred)

1. Locate the appropriate category section in `android-debloater.sh` (lines 133–662)
2. Add the package identifier to the `disable_android_package` call:
   ```bash
   disable_android_package \
       'existing.package.one' \
       'existing.package.two' \
       'new.vendor.package' \  # Add here
   ```
3. Maintain alphabetical ordering within vendor prefix
4. Test on target device

### Uninstall (Exceptional)

1. Locate or create an `uninstall_android_package` section
2. Add package identifier:
   ```bash
   uninstall_android_package \
       'existing.uninstall.one' \
       'new.vendor.package' \
   ```
3. **Verify**: Package is safe to uninstall (not required for OTA, not system-critical)
4. Document rationale in comment above

## Adding a Provisioning APK (Phone Only)

1. Add to provisioning section (lines 94–130):
   ```bash
   install_android_package 'com.new.package' 'https://example.com/app.apk'
   ```
2. For calling/messaging apps, wrap in SIM heuristic:
   ```bash
   if is_android_package_installed 'com.android.stk'; then
       install_android_package 'com.new.calling' 'https://example.com/calling.apk'
   fi
   ```
3. Verify URL serves correct APK
4. Consider adding checksum verification (future improvement)

## Modifying Device Classification

Current heuristic (line 88–91):
```bash
if is_android_package_installed 'com.google.android.tv.remote.service'; then
    DEVICE_TYPE='TV'
else
    DEVICE_TYPE='Phone'
fi
```

To change:
1. Replace package name with more reliable indicator
2. Test on both phone and TV devices
3. Update documentation

## Adding Device Targeting (Multi-Device Support)

**Current limitation**: No `-s <serial>` threading

To implement:
1. Add argument parsing at script top:
   ```bash
   TARGET_SERIAL=""
   while [[ $# -gt 0 ]]; do
       case $1 in
           --device) TARGET_SERIAL="$2"; shift 2 ;;
           *) shift ;;
       esac
   done
   ADB_CMD="adb${TARGET_SERIAL:+ -s $TARGET_SERIAL}"
   ```
2. Replace all `adb` with `"${ADB_CMD}"`
3. Replace all `adb shell` with `"${ADB_CMD}" shell`
4. Update `adb devices` filter to respect target

## Adding Dry-Run Mode

1. Add flag parsing:
   ```bash
   DRY_RUN=false
   # ... parse --dry-run
   ```
2. Wrap mutation calls:
   ```bash
   if [[ "${DRY_RUN}" = true ]]; then
       echo "[DRY-RUN] Would disable: ${PACKAGE_NAME}"
   else
       adb shell pm disable-user --user 0 "${PACKAGE_NAME}"
   fi
   ```
3. Add summary at end

## Updating APK URLs

1. Verify new URL serves correct APK version
2. Update URL in `install_android_package` call
3. Test download and install
4. Consider adding SHA256 checksum (future)

## Modifying Helper Functions

**Risk**: High — affects all catalogue operations

1. Read current implementation thoroughly
2. Preserve predicate semantics (skip if already satisfied)
3. Preserve `--user 0` targeting
4. Test each mutation type (enable, disable, uninstall, install, reinstall)
5. Verify idempotence

## Code Style Requirements

- 4 spaces indentation (no tabs)
- `local` for function variables
- `[[ ]]` for conditionals
- `$(command)` not backticks
- Quote all expansions: `"${VAR}"`
- Descriptive names (UPPER_SNAKE_CASE constants, lower_snake_case variables)
- Comments for non-obvious logic

## Validation Before Commit

```bash
# Syntax check
bash -n android-debloater.sh

# Lint
shellcheck android-debloater.sh

# Manual test on device
./android-debloater.sh
```