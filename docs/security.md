# Security

This document complements the root [SECURITY.md](../SECURITY.md) with implementation-level security analysis.

## Threat Model

```
Operator Host                    Android Device
┌─────────────────┐              ┌─────────────────┐
│ Script (user)   │              │ Package Manager │
│ ├─ adb client   │◄──USB/TCP──► │ (system uid)    │
│ ├─ wget         │              │                 │
│ └─ rm           │              │                 │
└─────────────────┘              └─────────────────┘
       │                                │
       ▼                                ▼
  Host FS                          Device State
  (temp APKs)                      (user 0 packages)
```

### Trust Boundaries

1. **Operator → Script** — Operator controls script content and execution
2. **Script → ADB** — Script invokes ADB with operator's privileges
3. **ADB → Device** — ADB transport requires prior USB debugging authorisation
4. **Script → Network** — Script downloads APKs from hard-coded HTTPS URLs
5. **Device → Script** — Device returns package listings and command results

## Security Properties

| Property | Status | Notes |
|----------|--------|-------|
| Authentication | Device-side | ADB requires USB debugging authorisation |
| Authorisation | Coarse | All operations as operator user; device trusts ADB |
| Confidentiality | Partial | Package names in console; no encryption |
| Integrity | Weak | No APK checksum verification |
| Non-repudiation | None | No audit trail |
| Availability | Best-effort | No DoS protection |

## Vulnerability Surface

### Command Injection

**Risk**: Low — Package names are hard-coded literals, not user input
**Location**: Helper functions interpolate `${PACKAGE_NAME}` into ADB commands
**Mitigation**: Package names validated by `grep` against `pm list packages` output format

### Path Traversal / Arbitrary File Write

**Risk**: Low — `PACKAGE_FILE="${PACKAGE_NAME}.apk"` derived from hard-coded name
**Location**: `install_android_package` function
**Mitigation**: Package names are alphanumeric with dots; no path separators

### Insecure APK Download

**Risk**: Medium — HTTPS but no checksum/signature verification
**Location**: `wget --continue "${PACKAGE_URL}" -O "${PACKAGE_FILE}"`
**Impact**: MITM or compromised upstream could deliver malicious APK
**Mitigation**: Android verifies APK signature on install; but no pinning

### ADB Command Manipulation

**Risk**: Low — Commands constructed from hard-coded literals
**Location**: All `adb shell pm ...` calls
**Mitigation**: No user input in command construction

### Information Exposure

**Risk**: Low — Package names and ADB output to console
**Location**: `echo` statements and command passthrough
**Impact**: Reveals device software inventory to terminal observers

## Security Controls

| Control | Implementation | Gap |
|---------|----------------|-----|
| Transport security | ADB (USB/TCP with auth) | No encryption on TCP |
| APK integrity | Android install verification | No host-side checksum |
| Least privilege | Runs as operator user | Requires ADB access |
| Input validation | Hard-coded literals only | No external config |
| Audit logging | None | No security event log |

## Recommendations

1. **Add APK checksum verification** — Store SHA256 hashes alongside URLs
2. **Pin APK URLs with hashes** — Fail download if hash mismatch
3. **Add `--device` flag** — Explicit device targeting to avoid ambiguity
4. **Implement dry-run mode** — Preview without mutation
5. **Add final audit summary** — Log all mutations for review
6. **Consider `set -euo pipefail`** — Fail fast on errors