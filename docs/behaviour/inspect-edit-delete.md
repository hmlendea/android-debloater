# Inspect, Edit, Delete Behaviour

This document describes the package inspection, modification, and removal behaviours available through the script and manual ADB commands.

## Script Behaviours

### Inspect (Probe)

The script provides two probe operations via helper functions:

| Operation | Function | Command | Returns |
|-----------|----------|---------|---------|
| Check installed | `is_android_package_installed` | `adb shell pm list packages --user 0` | 0 if installed, 1 if not |
| Check disabled | `is_android_package_disabled` | `adb shell pm list packages --user 0 -d` | 0 if disabled/absent, 1 if enabled |

**Usage in script:** Called before every mutation to skip unnecessary operations.

### Edit (Disable/Enable)

| Operation | Function | Command | Precondition |
|-----------|----------|---------|--------------|
| Disable | `disable_android_package` | `adb shell pm disable-user --user 0 <pkg>` | Package installed and not disabled |
| Enable | `enable_android_package` | `adb shell pm enable --user 0 <pkg>` | Package disabled |

**Behaviour:**
- Disable: Primary debloat operation; preserves package data, reversible
- Enable: Recovery operation; restores package to enabled state

### Delete (Uninstall/Reinstall)

| Operation | Function | Command | Precondition |
|-----------|----------|---------|--------------|
| Uninstall | `uninstall_android_package` | `adb shell pm uninstall --user 0 <pkg>` | Package installed and enabled |
| Reinstall | `reinstall_android_package` | `adb shell pm install-existing --user 0 <pkg>` | Package not installed (but in system image) |
| Install (APK) | `install_android_package` | `adb install --user 0 <file.apk>` | Package not installed |

**Behaviour:**
- Uninstall: Removes package for user 0; data may be preserved; not easily reversible
- Reinstall: Restores system package from device image; only works if package still in system partition
- Install: Installs third-party APK; used for provisioning alternatives

## Manual Recovery Commands

Operators can manually invoke these ADB commands for recovery:

```bash
# Re-enable a disabled package
adb shell pm enable --user 0 <package.name>

# Reinstall an uninstalled system package (if still in system image)
adb shell pm install-existing --user 0 <package.name>

# List disabled packages
adb shell pm list packages --user 0 -d

# List all packages for user 0
adb shell pm list packages --user 0
```

## Behavioural Guarantees

| Guarantee | Scope | Notes |
|-----------|-------|-------|
| Idempotent disable | `disable_android_package` | Skips if already disabled |
| Idempotent enable | `enable_android_package` | Skips if not disabled |
| Idempotent install | `install_android_package` | Skips if already installed |
| Idempotent uninstall | `uninstall_android_package` | Skips if not installed or disabled |
| Idempotent reinstall | `reinstall_android_package` | Skips if installed |

## Limitations

- No dry-run mode to preview changes
- No selective execution (all-or-nothing catalogue)
- No package exclusion list mechanism
- No confirmation prompts
- No rollback on failure
- No final summary of changes