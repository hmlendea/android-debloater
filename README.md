# Android Debloater (ADB)

Debloat Android phones and Android TV devices using a single Bash script and ADB.

The script is intentionally conservative by default: it mostly **disables** packages instead of uninstalling them, which is easier to recover from and usually safer for OTA updates.

## What This Script Does

- Detects a connected Android device over ADB.
- Detects device type (`Phone` vs `TV`) using installed package heuristics.
- Optionally installs alternative apps on phones (Aurora Store, F-Droid, Fossify apps, etc.) if missing.
- Disables a large list of vendor/Google/social/utility packages.
- Uninstalls a small subset of packages where explicitly configured.

## Why Disable Instead of Uninstall?

Disabling user 0 packages generally has lower risk:

- Easier rollback (can be re-enabled from Settings or ADB).
- Better OTA compatibility compared with broad uninstalling.
- Good debloat impact without removing system package metadata.

Uninstalling is still used in a few targeted places in this script.

## Prerequisites

- Linux/macOS (or WSL/Git Bash with ADB available)
- `adb`
- `wget`
- USB debugging enabled on the Android device
- Authorized ADB connection (`Allow USB debugging` prompt accepted)

Install prerequisites:
 - Arch Linux:
```bash
sudo pacman -Syy
sudo pacman -S android-tools
```
 - Debian/Ubuntu:
```bash
sudo apt update
sudo apt install -y android-tools-adb wget
```

Verify that the device is connected:

```bash
adb devices
```

You should see your device with the state `device`.

## Quick Start

From the project directory:

```bash
chmod +x android-debloater.sh
./android-debloater.sh
```

## Important Safety Notes

- Read the package lists before running.
- This script runs immediately; there is no interactive confirmation.
- Some categories disable core apps (contacts, dialer, SMS, camera, file manager, etc.).
- A few packages are uninstalled, not just disabled.
- Results vary by OEM/ROM/version; some package names may not exist on your device.

## Recommended Workflow

1. Back up important data.
2. Review/edit package groups in `android-debloater.sh` before first run.
3. Run the script once.
4. Reboot the device.
5. Test calls, messaging, camera, notifications, and updates.
6. Re-enable anything needed.

## Rollback / Recovery

### Re-enable a package

```bash
adb shell pm enable --user 0 <package.name>
```

### Reinstall an uninstalled system package (if still present in system image)

```bash
adb shell pm install-existing --user 0 <package.name>
```

### List disabled packages

```bash
adb shell pm list packages --user 0 -d
```

### List all user 0 packages

```bash
adb shell pm list packages --user 0
```

## Customizing

Edit package groups directly in `android-debloater.sh`:

- Keep a package: comment out its line.
- Add a package to disable: add it under a `disable_android_package` block.
- Remove uninstall actions unless you explicitly want them.

Tip: start conservative and expand gradually.

## Known Behavior

- If no ADB device is connected, the script exits with an error.
- If a package is already disabled/missing, operations are skipped.
- Phone-only app installation block is skipped for detected TV devices.

## Troubleshooting

### `No ADB devices found!`

- Ensure USB cable supports data.
- Re-run `adb devices` and accept authorization prompt.
- Try restarting ADB:

```bash
adb kill-server
adb start-server
adb devices
```

### Permission denied when running script

```bash
chmod +x android-debloater.sh
```

### A disabled app is needed again

Re-enable it from Android Settings (Apps) or via ADB using:

```bash
adb shell pm enable --user 0 <package.name>
```

## Disclaimer

Use at your own risk. This script can affect core device functionality depending on your ROM and package set. Always review changes and keep a recovery path.

## License

Licensed under the GNU General Public License v3.0 or later.
See [LICENSE](./LICENSE) for details.
