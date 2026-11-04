# Repository Overview

## Purpose

Android Debloater is a self-hosted Bash script that automates the debloating of Android phones and Android TV devices through ADB. The script detects connected devices, classifies them as phones or TVs, optionally installs alternative applications on phones, and then executes a curated package deactivation pass that primarily disables (rather than uninstalls) bloatware packages.

## Scope

The repository contains:
- A single orchestration script (`android-debloater.sh`) — 662 lines
- GitHub Actions workflow for ShellCheck validation (`.github/workflows/bash.yml`)
- Root documentation: `README.md`, `ARCHITECTURE.md`, `SECURITY.md`, `PRIVACY.md`, `CONTRIBUTING.md`, `LICENSE`

The repository does not contain:
- Compiled binaries or packaged distributions
- Device-side components or Android applications
- Automated device-level test suites
- Configuration files or externalised package catalogues

## Entry Points

| Entry Point | Description |
|-------------|-------------|
| `android-debloater.sh` | Main executable script; invoked directly by the operator |
| `.github/workflows/bash.yml` | CI workflow triggered on push/PR to `master` and manual dispatch |

## Principal Capabilities

1. **Device detection** — Enumerates authorised ADB devices; aborts if none found
2. **Device classification** — Heuristic check for `com.google.android.tv.remote.service` to distinguish TV from Phone
3. **Phone provisioning** — Downloads and installs alternative APKs (Aurora Store, F-Droid, Fossify apps, Breezy Weather) when absent
4. **Package deactivation** — Iterates through ~300 hard-coded package identifiers grouped by vendor/category, disabling or uninstalling each
5. **Conservative default** — Prefers `pm disable-user` over `pm uninstall` for recovery safety and OTA compatibility

## Runtime Topology

```
Operator Host                          Android Device
┌─────────────────────┐                ┌─────────────────────┐
│ Bash (script)       │                │ Package Manager     │
│ ├─ adb client       │◄──USB/TCP──►   │ ├─ pm list packages │
│ ├─ wget             │                │ ├─ pm disable-user  │
│ └─ rm               │                │ ├─ pm uninstall     │
└─────────────────────┘                │ └─ pm install-existing│
                                       └─────────────────────┘
```

## Major Integrations

| Integration | Purpose | Direction |
|-------------|---------|-----------|
| ADB (`android-tools-adb`) | Device discovery, package inspection, mutation | Outbound |
| `wget` | HTTPS APK downloads for phone provisioning | Outbound |
| Aurora Store, F-Droid, Fossify, Breezy Weather | Alternative APK sources | Inbound (download) |
| GitHub Actions | ShellCheck validation on push/PR | Inbound (workflow) |

## System-Wide Invariants

1. **Single-target assumption** — Script does not pass `-s <serial>` to ADB commands; assumes one active device or unambiguous ADB context
2. **User 0 scope** — All package mutations target `--user 0` exclusively
3. **Disable-over-uninstall** — Default operation is disable; uninstall reserved for explicit exceptions
4. **Best-effort execution** — No transactional rollback, retry, or failure aggregation after startup
5. **Heuristic classification** — Device type and SIM capability inferred from package presence, not formal APIs
6. **Static catalogue** — Package groups are hard-coded; relevance varies by OEM, ROM, Android version