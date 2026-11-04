# Startup and Rendering Flow

This flow covers the initial bootstrap, device detection, classification, and the transition into the main debloat execution.

## Sequence

```mermaid
sequenceDiagram
    participant Operator
    participant Script
    participant ADB
    participant Device

    Operator->>Script: ./android-debloater.sh
    Script->>ADB: adb devices
    ADB->>Device: Query authorised devices
    Device-->>ADB: Device list
    ADB-->>Script: stdout (serial + status)
    Script->>Script: Filter for "device" status
    alt No authorised devices
        Script->>Operator: "No ADB devices found!" (stderr)
        Script->>Operator: exit 1
    else Devices found
        Script->>ADB: adb shell pm list packages --user 0
        ADB->>Device: pm list packages --user 0
        Device-->>ADB: Package list
        ADB-->>Script: Package list
        Script->>Script: grep for com.google.android.tv.remote.service
        alt Package found
            Script->>Script: DEVICE_TYPE='TV'
        else Package not found
            Script->>Script: DEVICE_TYPE='Phone'
        end
    end
```

## Decision Points

| Decision | Condition | True Branch | False Branch |
|----------|-----------|-------------|--------------|
| Device present | `ADB_DEVICES` non-empty | Continue | Exit 1 |
| Device type | `com.google.android.tv.remote.service` installed | TV | Phone |

## Data Transformations

1. `adb devices` raw output → filtered to authorised device serials
2. `pm list packages` output → `sed` sanitisation → `grep` exact match

## Side Effects

- None (read-only operations)

## Error Paths

- `adb` not in PATH → command not found → script fails
- ADB daemon not running → `adb devices` fails → no devices → exit 1
- Device unauthorised → not in "device" list → exit 1