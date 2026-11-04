# API Reference Index

## Not Applicable

Android Debloater is a **standalone Bash script** with no programmatic API surface.

There are no:
- Public functions or classes
- HTTP/REST endpoints
- gRPC services
- GraphQL schemas
- CLI subcommands with structured output
- Library exports
- Plugin interfaces

## Script Interface

The only interface is direct execution:

```bash
./android-debloater.sh
```

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success (or best-effort completion) |
| 1 | No ADB devices found |
| Other | Bash/shell error (syntax, command not found) |

### Environment Variables

None consumed.

### Arguments

None accepted (currently).

### Output

Human-readable console output with ANSI colour codes. Not machine-parseable.

## Internal Functions (Not Public API)

These functions exist in the script but are **not** a stable interface:

| Function | Purpose |
|----------|---------|
| `is_android_package_installed` | Probe package existence |
| `is_android_package_disabled` | Probe package disabled state |
| `enable_android_package` | Re-enable package |
| `disable_android_package` | Disable package |
| `uninstall_android_package` | Uninstall package |
| `install_android_package` | Download and install APK |

**Do not depend on these.** They may change without notice.

## ADB Commands Used

The script invokes these ADB commands internally:

| Command | Purpose |
|---------|---------|
| `adb devices` | Device detection |
| `adb shell pm list packages --user 0` | Package enumeration |
| `adb shell pm disable-user --user 0 <pkg>` | Disable package |
| `adb shell pm enable --user 0 <pkg>` | Enable package |
| `adb shell pm uninstall --user 0 <pkg>` | Uninstall package |
| `adb shell pm install-existing --user 0 <pkg>` | Reinstall system package |
| `adb install -r <file.apk>` | Install APK |

## See Also

- [Change Guide](../change-guide.md) — How to modify the script
- [API Usage Examples](../api-usage-examples.md) — Integration patterns
- [Components: Application Services](../components/application-services.md) — Helper function details