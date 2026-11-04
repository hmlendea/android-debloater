# Frequently Asked Questions

## General

### What does this script do?
Disables/uninstalls ~300 pre-installed Android packages (bloatware) and optionally installs 14 curated open-source alternatives on phones.

### Is it safe?
**Mostly.** Uses `disable-user` (reversible) for ~97% of packages. Uninstall is used for ~10 packages deemed safe. Always review the catalogue before running.

### Can I undo changes?
Yes. See [Recovery](#recovery) below.

### Does it root the device?
No. Uses ADB only; no root required.

### Does it work on all Android devices?
Tested on stock Android, Pixel, Samsung, Xiaomi, OnePlus. OEM-specific packages may vary. TV devices skip provisioning.

## Usage

### How do I run it?
```bash
git clone https://github.com/.../android-debloater.git
cd android-debloater
chmod +x android-debloater.sh
./android-debloater.sh
```

### Prerequisites?
- Android device with USB debugging enabled
- ADB authorised on device
- Host: `bash`, `adb`, `wget`

### Can I target a specific device?
**Not currently.** Script uses first device from `adb devices`. Workaround: disconnect other devices.

### Can I preview changes without applying?
**Not currently.** No `--dry-run` mode. Review catalogue in script before running.

### How long does it take?
2–5 minutes depending on device and network (for provisioning downloads).

## Recovery

### Re-enable a disabled package
```bash
adb shell pm enable --user 0 <package.name>
```

### Reinstall uninstalled system package
```bash
adb shell pm install-existing --user 0 <package.name>
```

### Reinstall uninstalled user package
Requires APK file. Not automated.

### Factory reset
Nuclear option: Settings → System → Reset → Factory data reset.

## Provisioning

### What apps are installed on phones?
Aurora Store, F-Droid, Fossify apps (Gallery, File Manager, Keyboard, etc.), Breezy Weather, and calling/messaging replacements (if SIM detected).

### Why only on phones?
TV devices don't need phone-centric apps (dialer, SMS, contacts).

### Can I customise the provisioning list?
Edit the script. See [Change Guide](change-guide.md#adding-a-provisioning-apk-phone-only).

### APK download fails?
Check network. URLs may become stale. Update in script.

## Troubleshooting

### "No ADB devices found!"
- Enable USB debugging on device
- Authorise ADB on device prompt
- Check `adb devices` shows device

### Package not disabled?
- May already be disabled
- May not exist on this device/ROM
- Check `adb shell pm list packages --user 0 | grep <name>`

### Script exits early?
- No `set -e`; should continue through errors
- Check for syntax error: `bash -n android-debloater.sh`

## Contributing

### How to add a package?
See [Change Guide](change-guide.md#adding-a-package-to-the-debloat-catalogue).

### How to report a problem?
GitHub Issues with: device model, Android version, package name, expected vs actual behaviour.

## Licensing

### Can I use this commercially?
Yes, under GPL v3.0. Must provide source and preserve license.

### Can I fork and modify?
Yes, GPL v3.0 permits modification and distribution under same license.