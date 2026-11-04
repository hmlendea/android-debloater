# Phone Provisioning Flow

This flow covers the alternative application installation that occurs only for devices classified as phones.

## Sequence

```mermaid
sequenceDiagram
    participant Script
    participant ADB
    participant Device
    participant Network
    participant FS as Host FS

    Note over Script: DEVICE_TYPE='Phone'
    loop For each curated APK
        Script->>ADB: adb shell pm list packages --user 0
        ADB->>Device: pm list packages --user 0
        Device-->>ADB: Package list
        ADB-->>Script: Package list
        Script->>Script: is_android_package_installed check
        alt Package already installed
            Script->>Script: Skip (return early)
        else Package absent
            Script->>Network: wget --continue URL -O file.apk
            Network-->>FS: APK binary
            Script->>ADB: adb install --user 0 file.apk
            ADB->>Device: Install APK
            Device-->>ADB: Install result
            ADB-->>Script: Install result
            Script->>FS: rm file.apk
        end
    end
    Note over Script: SIM heuristic for calling/messaging apps
    Script->>ADB: adb shell pm list packages --user 0
    ADB->>Device: pm list packages --user 0
    Device-->>ADB: Package list
    ADB-->>Script: Package list
    Script->>Script: grep for com.android.stk
    alt STK present (SIM support)
        loop For each calling/messaging APK
            [Same install sequence]
        end
    end
```

## Curated APKs (Phone Only)

| Package | URL | Condition |
|---------|-----|-----------|
| `com.aurora.store` | Aurora Store 4.6.2 | Always |
| `org.fdroid.fdroid` | F-Droid | Always |
| `org.fossify.calculator` | Fossify Calculator | Always |
| `org.fossify.calendar` | Fossify Calendar | Always |
| `org.fossify.camera` | Fossify Camera | Always |
| `org.fossify.clock` | Fossify Clock | Always |
| `org.fossify.filemanager` | Fossify File Manager | Always |
| `org.fossify.gallery` | Fossify Gallery | Always |
| `org.fossify.home` | Fossify Home | Always |
| `org.fossify.keyboard` | Fossify Keyboard | Always |
| `org.breezyweather` | Breezy Weather | Always |
| `org.fossify.contacts` | Fossify Contacts | If `com.android.stk` present |
| `org.fossify.phone` | Fossify Phone | If `com.android.stk` present |
| `org.fossify.messages` | Fossify Messages | If `com.android.stk` present |

## Decision Points

| Decision | Condition | True Branch | False Branch |
|----------|-----------|-------------|--------------|
| Package installed | `is_android_package_installed` | Skip | Download & install |
| SIM support | `com.android.stk` installed | Install calling/messaging apps | Skip calling/messaging |

## Data Transformations

1. Package name + URL → `wget` download → `${PACKAGE_NAME}.apk` in CWD
2. APK file → `adb install` → Device package manager
3. Temp file → `rm` → Removed

## Side Effects

- Network traffic (HTTPS downloads)
- Temporary files in CWD (created and removed)
- Device package state mutated (new packages installed)

## Error Paths

- `wget` fails (network, 404, timeout) → `adb install` fails → temp file still removed
- `adb install` fails (signature, version, space) → error printed → temp file removed → continue
- `rm` fails (permissions) → file left in CWD (rare)