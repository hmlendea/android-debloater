# Invariants

System-wide invariants that must hold for correct operation.

## Runtime Invariants

| Invariant | Description | Enforcement |
|-----------|-------------|-------------|
| **Single ADB Target** | Script operates on exactly one device | `adb devices` filtered to single line; no `-s` support |
| **User 0 Scope** | All package operations target `--user 0` | Hard-coded in all helper functions |
| **Disable Over Uninstall** | Default mutation is disable, not uninstall | Catalogue uses `disable_android_package` for ~97% of packages |
| **Best-Effort Continuation** | Script continues after individual failures | No `set -e`; no error aggregation |
| **Heuristic Classification** | Device type determined by single package probe | `com.google.android.tv.remote.service` presence |
| **Static Catalogue** | Package list fixed at script edit time | No external config, no dynamic discovery |
| **Phone-Only Provisioning** | APK installation only on classified phones | `if [[ "${DEVICE_TYPE}" = "Phone" ]]` guard |
| **No Host Persistence** | No state written to host filesystem beyond temp APKs | Only `${PACKAGE_NAME}.apk` in CWD |

## Data Invariants

| Invariant | Description |
|-----------|-------------|
| **Package Identifier Format** | Reverse-DNS: `com.vendor.app` or `com.vendor.app.component` |
| **ADB Output Stability** | `pm list packages` format: `package:<identifier>` |
| **APK Filename Derivation** | `${PACKAGE_NAME}.apk` — no path separators in package names |
| **Temporary File Lifetime** | APK files deleted after install attempt (success or failure) |

## Behavioural Invariants

| Invariant | Description |
|-----------|-------------|
| **Idempotent Probes** | `is_android_package_installed` / `is_android_package_disabled` return same result on repeated calls |
| **Idempotent Mutations** | `enable_android_package` on enabled package succeeds silently; `disable_android_package` on disabled package succeeds silently |
| **No Cross-User Effects** | Operations on user 0 do not affect other users |
| **No System Partition Modification** | Script never remounts `/system` or modifies system image |

## Environmental Invariants

| Invariant | Description |
|-----------|-------------|
| **ADB Authorised** | Device has previously authorised host's ADB key |
| **USB Debugging Enabled** | Device setting persists across reboots |
| **Network Reachability** | HTTPS endpoints for APK downloads accessible from host |
| **Bash ≥ 4.0** | Script uses `[[ ]]`, `local`, arrays — requires Bash 4+ |

## Invariant Violations → Failure Modes

| Violated Invariant | Symptom | Recovery |
|--------------------|---------|----------|
| Multiple ADB devices | Script picks first; wrong device debloated | Disconnect extra devices |
| User 0 not primary | Changes don't affect visible user | Manual `pm` commands for correct user |
| Package already uninstalled | `disable` fails silently | N/A (already gone) |
| APK URL 404 | `wget` fails; install skipped | Update URL in script |
| Network blocked | Provisioning fails silently | Check connectivity |
| Bash < 4.0 | Syntax errors on `[[ ]]` | Upgrade Bash |