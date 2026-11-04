# State and Persistence

## State Overview

Android Debloater maintains **no persistent host state**. All state resides on the Android device.

```
Host (Transient)                    Device (Persistent)
┌─────────────────────┐             ┌─────────────────────┐
│ Process memory      │             │ Package Manager DB  │
│ ├─ DEVICE_TYPE      │             │ ├─ Enabled packages │
│ ├─ Package lists    │             │ ├─ Disabled packages│
│ └─ Temp APK paths   │             │ └─ Uninstalled pkgs │
└─────────────────────┘             └─────────────────────┘
```

## Host-Side Transient State

| Variable | Scope | Lifetime | Purpose |
|----------|-------|----------|---------|
| `DEVICE_TYPE` | Global | Process | 'Phone' or 'TV' |
| `PACKAGE_NAME` | Function-local | Call | Current package being processed |
| `PACKAGE_FILE` | Function-local | Call | `${PACKAGE_NAME}.apk` path |
| `PACKAGE_URL` | Function-local | Call | APK download URL |
| `adb devices` output | Function-local | Call | Device detection |

## Device-Side Persistent State

### Package Manager Database (User 0)

| State | Command to Query | Mutations |
|-------|------------------|-----------|
| Enabled | `pm list packages --user 0 -e` | `enable`, `install-existing` |
| Disabled | `pm list packages --user 0 -d` | `disable-user` |
| Uninstalled (system) | `pm list packages --user 0 -u` | `uninstall`, `install-existing` |
| Uninstalled (user) | Not listed | `uninstall` |

### State Transitions

```
ENABLED ──disable-user──► DISABLED
  ▲                        │
  │                        ▼
  │                  (uninstall)
  │                        │
  └──install-existing────┘
        (system packages only)
```

**Note**: User-installed packages cannot be restored via `install-existing` after uninstall.

## Temporary Files

| File | Location | Created By | Cleaned By |
|------|----------|------------|------------|
| `${PACKAGE_NAME}.apk` | CWD | `wget` in `install_android_package` | `rm -f` in same function |

**Lifetime**: Single function invocation
**Failure cleanup**: `rm -f` executes regardless of `wget`/`adb` success

## No Host Persistence

The script does **not** create or modify:
- Configuration files
- Log files
- State databases
- Cache directories
- User preference files

Each execution is independent and stateless on the host.

## Recovery State

After script execution, device state changes are visible via:

```bash
# Disabled packages (recoverable)
adb shell pm list packages --user 0 -d

# Uninstalled system packages (recoverable via install-existing)
adb shell pm list packages --user 0 -u

# Uninstalled user packages (NOT recoverable automatically)
# Requires APK reinstall
```

## Invariants

| Invariant | Description |
|-----------|-------------|
| No host state survives process exit | All host state is in-memory |
| Device state only modified via ADB | No direct filesystem access |
| Temp files cleaned per-package | No accumulation across runs |
| User 0 only | No multi-user state management |