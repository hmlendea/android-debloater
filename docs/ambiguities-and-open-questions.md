# Ambiguities and Open Questions

## Unresolved Design Questions

### 1. Device Classification Reliability

**Question**: Is `com.google.android.tv.remote.service` a reliable TV indicator across all Android TV devices and future versions?

**Current State**: Single-package heuristic, no fallback.
**Impact**: Misclassification gates provisioning incorrectly.
**Resolution Needed**: Test on more TV devices; consider multi-package heuristic or `getprop ro.build.characteristics`.

### 2. Multi-Device Targeting

**Question**: Should script support `-s <serial>` for multi-device environments?

**Current State**: Uses first device from `adb devices`.
**Impact**: Operators with multiple devices must disconnect others.
**Resolution Needed**: Decide if feature is in scope; if so, implement argument parsing.

### 3. Dry-Run Mode

**Question**: Should a `--dry-run` flag be added for safe preview?

**Current State**: No preview; script executes immediately.
**Impact**: Operators cannot validate catalogue against their device before mutation.
**Resolution Needed**: Decide priority; implement if accepted.

### 4. Uninstall vs Disable Boundary

**Question**: What criteria determine whether a package is uninstalled vs disabled?

**Current State**: ~10 packages uninstalled; ~290 disabled. Rationale not documented per-package.
**Impact**: Operators cannot assess risk of uninstall targets.
**Resolution Needed**: Document per-package rationale or move all to disable.

### 5. APK URL Longevity

**Question**: How should stale APK URLs be handled?

**Current State**: Hard-coded URLs; no checksum; no fallback.
**Impact**: Provisioning silently fails when URLs expire.
**Resolution Needed**: Add checksum verification; consider URL redirect handling; document update cadence.

### 6. Error Handling Philosophy

**Question**: Should script adopt `set -euo pipefail` or maintain best-effort?

**Current State**: No strict mode; continues through failures.
**Impact**: Silent failures; no error aggregation.
**Resolution Needed**: Decide trade-off between robustness and visibility.

### 7. Logging Requirements

**Question**: Should structured logging be added?

**Current State**: Console `echo` only; no log file.
**Impact**: No audit trail; hard to debug.
**Resolution Needed**: Define logging requirements; implement if accepted.

### 8. User Targeting

**Question**: Should script support `--user <id>` for multi-user devices?

**Current State**: Hard-coded `--user 0`.
**Impact**: Work profiles and secondary users unaffected.
**Resolution Needed**: Determine if multi-user support is needed.

## Known Gaps

| Gap | Severity | Effort |
|-----|----------|--------|
| No automated device tests | Medium | High |
| No APK checksum verification | Medium | Low |
| No dry-run mode | Medium | Low |
| No multi-device support | Low | Medium |
| No structured logging | Low | Medium |
| No per-package uninstall rationale | Low | Low |
| No OEM/ROM variant catalogues | Medium | High |
| No signal handling / cleanup trap | Low | Low |

## TODO Items in Code

None currently marked with `TODO`/`FIXME` comments in `android-debloater.sh`.

## Community Questions

These questions appear in issues/discussions but lack documented answers:

1. **"Does this work on my device?"** — No compatibility matrix maintained.
2. **"Can I exclude certain packages?"** — No exclusion mechanism; must edit script.
3. **"How do I restore everything?"** — Recovery commands documented but no single "undo" script.
4. **"Is package X safe to uninstall?"** — No per-package safety documentation.

## Recommendations for Resolution

1. **Create GitHub Discussion** for each open question
2. **Prioritise** by operator impact (dry-run, multi-device, checksums)
3. **Document decisions** in `design-decisions.md` when resolved
4. **Update invariants** when behaviour changes