# Dependencies

## External Dependencies

| Dependency | Version Requirement | Purpose | Integration Point |
|------------|---------------------|---------|-------------------|
| `bash` | ≥ 4.0 | Script interpreter | Shebang `#!/bin/bash` |
| `adb` (Android Platform Tools) | Recent | Device communication, package management | All `adb` commands |
| `wget` | Any with `--continue` | HTTPS APK downloads | `install_android_package` |
| `grep` | POSIX | Text filtering | Device detection, package probes |
| `sed` | POSIX | Text sanitisation | Package probe output cleaning |
| `rm` | POSIX | Temporary file cleanup | `install_android_package` |

## Runtime Dependencies (Host)

| Tool | Minimum Version | Verification |
|------|-----------------|--------------|
| `bash` | 4.0 | `bash --version` |
| `adb` | Platform Tools 30+ | `adb version` |
| `wget` | 1.20+ | `wget --version` |

## Runtime Dependencies (Device)

| Component | Requirement |
|-----------|-------------|
| Android | 5.0+ (API 21+) for `pm disable-user` |
| ADB daemon | Authorised and running |
| Package manager | Standard `pm` commands available |

## Upstream APK Providers (Network Dependencies)

| Provider | Packages | URL Stability |
|----------|----------|---------------|
| Aurora Store | `com.aurora.store` | Versioned URL (4.6.2) |
| F-Droid | `org.fdroid.fdroid` | Stable redirect |
| Fossify | 9 packages | Versioned URLs (e.g., `_3.apk`, `_9.apk`) |
| Breezy Weather | `org.breezyweather` | Versioned URL (`_50208.apk`) |

**Risk**: All URLs hard-coded; no fallback mirrors; no checksum verification.

## Development Dependencies

| Tool | Purpose | Installation |
|------|---------|--------------|
| ShellCheck | Static analysis (CI) | `apt install shellcheck` / `pacman -S shellcheck` |
| Git | Version control | Standard |

## CI Dependencies

| Dependency | Source | Version Pinning |
|------------|--------|-----------------|
| `actions/checkout` | GitHub Marketplace | `@v7` (immutable commit) |
| `ubuntu-latest` | GitHub-hosted runners | Floating (latest LTS) |
| ShellCheck | Ubuntu package | Distribution default |

## Dependency Direction

```
android-debloater.sh
    ├── requires → bash (interpreter)
    ├── requires → adb (device ops)
    ├── requires → wget (downloads)
    ├── requires → grep, sed, rm (text/fs ops)
    ├── downloads from → Aurora Store, F-Droid, Fossify, Breezy Weather
    └── validated by → ShellCheck (CI)
```

## Version Compatibility Matrix

| Android Version | `pm disable-user` | `pm uninstall` | `pm install-existing` | Notes |
|-----------------|-------------------|----------------|----------------------|-------|
| 5.0–6.0 | ✅ | ✅ | ✅ | Basic support |
| 7.0–9.0 | ✅ | ✅ | ✅ | Improved multi-user |
| 10–12 | ✅ | ✅ | ✅ | Scoped storage changes |
| 13–14 | ✅ | ✅ | ✅ | Runtime permission changes |
| 15+ | ✅ | ✅ | ✅ | Predicted compatible |

## OEM-Specific Considerations

| OEM | Package Prefixes | Known Variations |
|-----|------------------|------------------|
| Google | `com.google.android.*` | Pixel-specific packages |
| Samsung | `com.samsung.*`, `com.sec.*` | One UI variants |
| Xiaomi | `com.miui.*`, `com.xiaomi.*` | MIUI/HyperOS variants |
| Asus | `com.asus.*` | ZenUI variants |
| Oppo/OnePlus | `com.oplus.*`, `com.heytap.*`, `com.coloros.*` | ColorOS/OxygenOS |
| Motorola | `com.motorola.*` | MyUX variants |
| Nothing | `com.nothing.*` | Nothing OS |

## Dependency Update Policy

- **Host tools**: Operator responsibility (system package manager)
- **ADB**: Update with Android Platform Tools releases
- **APK URLs**: Manual update when upstream versions change
- **ShellCheck**: Updated via CI runner image refresh