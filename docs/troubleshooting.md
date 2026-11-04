# Troubleshooting

## Common Issues

### No ADB Devices Found

**Symptom**: `No ADB devices found!` and script exits.

**Causes**:
- USB debugging not enabled on device
- Device not authorised for ADB
- Faulty cable/port
- ADB server not running

**Solutions**:
```bash
# 1. Enable USB debugging
# Settings → Developer options → USB debugging

# 2. Authorise ADB
# Unplug/replug device, accept prompt on device

# 3. Verify
adb devices
# Should show: <serial>    device

# 4. Restart ADB server
adb kill-server && adb start-server
```

### Device Shows "unauthorized"

**Symptom**: `adb devices` shows `<serial>    unauthorized`

**Solution**: Accept the RSA fingerprint prompt on the device screen.

### Package Not Disabled/Uninstalled

**Symptom**: Package still appears in `pm list packages --user 0 -e` after script.

**Causes**:
- Package name differs on this device/ROM
- Package already disabled (script skips silently)
- Package is system-critical (disable fails)
- Wrong user (script targets user 0 only)

**Diagnosis**:
```bash
# Check exact package name
adb shell pm list packages --user 0 | grep -i <partial>

# Check current state
adb shell pm list packages --user 0 -d | grep <name>  # disabled
adb shell pm list packages --user 0 -e | grep <name>  # enabled

# Try manual disable
adb shell pm disable-user --user 0 <exact.name>
```

### Provisioning APK Download Fails

**Symptom**: `wget` errors during phone provisioning.

**Causes**:
- Network connectivity
- URL changed/expired
- TLS certificate issue
- GitHub rate limiting

**Solutions**:
```bash
# Test URL manually
wget "https://example.com/app.apk"

# Check date/time (TLS requires correct time)
date

# Update URL in script (see change-guide.md)
```

### APK Install Fails

**Symptom**: `adb install` fails after download.

**Causes**:
- APK signature mismatch (wrong architecture/variant)
- Package already installed with different signature
- Insufficient storage
- Android version incompatible

**Diagnosis**:
```bash
# Check error output
adb install -r /path/to/app.apk

# Common: INSTALL_FAILED_VERSION_DOWNGRADE
# → Existing version newer; skip or uninstall first
```

### Script Exits Unexpectedly

**Symptom**: Script stops mid-execution without error.

**Causes**:
- Syntax error (run `bash -n android-debloater.sh`)
- `adb` command not found
- `wget` command not found
- Bash version < 4.0

**Solutions**:
```bash
# Validate syntax
bash -n android-debloater.sh

# Check dependencies
which bash adb wget
bash --version  # Must be ≥ 4.0
```

### Multiple Devices Connected

**Symptom**: Script operates on wrong device.

**Cause**: Script uses first device from `adb devices`.

**Workaround**:
```bash
# Disconnect unwanted devices
# Or run ADB server per-device (advanced)
```

### TV Classified as Phone (or Vice Versa)

**Symptom**: Provisioning runs on TV, or skipped on phone.

**Cause**: Heuristic package `com.google.android.tv.remote.service` presence differs.

**Diagnosis**:
```bash
# Check on device
adb shell pm list packages --user 0 | grep tv.remote
```

**Fix**: Update heuristic in script (see change-guide.md).

## Recovery Procedures

### Re-enable Single Package
```bash
adb shell pm enable --user 0 com.example.package
```

### Re-enable All Disabled (Nuclear)
```bash
adb shell pm list packages --user 0 -d | cut -d: -f2 | \
  xargs -I {} adb shell pm enable --user 0 {}
```

### Reinstall System Package
```bash
adb shell pm install-existing --user 0 com.example.package
```

### Full Factory Reset
Settings → System → Reset → Factory data reset (erases all data).

## Getting Help

1. Run with `bash -x android-debloater.sh` for trace
2. Capture full output
3. File GitHub Issue with:
   - Device model, Android version, ROM
   - Full command output
   - Expected vs actual behaviour