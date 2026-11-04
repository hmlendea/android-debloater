# Host and Composition Component

The host and composition component encompasses the script's process topology, entry point, and how it composes external tools (ADB, wget, rm) to achieve its goals.

## Responsibilities

- Process lifecycle: single foreground Bash process
- Tool composition: invokes `adb`, `wget`, `rm` as child processes
- Working directory management: uses CWD for temporary APK files
- Environment assumptions: requires `adb`, `wget`, `bash` in PATH

## Implementation

The entire script `android-debloater.sh` is the host component. Key composition patterns:

### ADB Composition

```bash
# Device enumeration
ADB_DEVICES=$(adb devices | grep -w "device" | grep -v "List")

# Package listing (probe)
adb shell pm list packages --user 0 | sed -e 's/^package://g' -e 's/[^a-zA-Z0-9.-]//g' | grep -q "^${PACKAGE_NAME}$"

# Package disable
adb shell pm disable-user --user 0 "${PACKAGE_NAME}"

# Package uninstall
adb shell pm uninstall --user 0 "${PACKAGE_NAME}"

# Package enable
adb shell pm enable --user 0 "${PACKAGE_NAME}"

# Package reinstall (system)
adb shell pm install-existing --user 0 "${PACKAGE_NAME}"

# APK install
adb install --user 0 "${PACKAGE_FILE}"
```

### wget Composition

```bash
wget --continue "${PACKAGE_URL}" -O "${PACKAGE_FILE}"
```

### rm Composition

```bash
rm "${PACKAGE_FILE}"
```

## Process Topology

```
┌─────────────────────────────────────────────────────────────┐
│ Bash Process (android-debloater.sh)                         │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ adb         │  │ wget        │  │ rm          │         │
│  │ (multiple)  │  │ (multiple)  │  │ (multiple)  │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
│         │                │                │                 │
│         ▼                ▼                ▼                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Android Device (via USB/TCP)                        │   │
│  │ HTTPS APK Sources                                   │   │
│  │ Host Filesystem (CWD)                               │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Environment Requirements

| Requirement | Purpose | Validation |
|-------------|---------|------------|
| `bash` | Script interpreter | Shebang `#!/bin/bash` |
| `adb` | Device communication | Implicit; fails at first `adb` call if absent |
| `wget` | APK downloads | Implicit; fails at first `wget` call if absent |
| `grep`, `sed` | Text processing | POSIX standard; assumed present |
| USB debugging + ADB authorisation | Device access | Checked via `adb devices` output |

## Working Directory Usage

- Temporary APK files written to `${PWD}/${PACKAGE_NAME}.apk`
- No dedicated temporary directory; relies on CWD being writable
- Files removed after `adb install` attempt (success or failure)

## Single-Target Assumption

The script does **not** pass `-s <serial>` to ADB commands. This means:

- If multiple devices are connected, ADB uses its default target resolution
- All operations apply to whatever device ADB selects
- No per-device orchestration or isolation

## Composition Limitations

- No parallel execution; all operations sequential
- No timeout control for ADB or wget commands
- No retry logic for transient failures
- No transaction boundary; each package operation independent