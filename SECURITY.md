# Security Policy

This document describes the security policy for Android Debloater, a self-hosted Bash script that automates Android package deactivation through ADB. The policy covers vulnerability reporting, supported versions, and coordinated disclosure expectations for the repository at https://github.com/hmlendea/android-debloater.

## 📑 Table of Contents

- [Supported Versions](#supported-versions)
- [Reporting a Vulnerability](#reporting-a-vulnerability)
- [Scope](#scope)
- [Disclosure Policy](#disclosure-policy)
- [Safe Harbour](#safe-harbour)
- [Recognition](#recognition)

## 🛡️ Supported Versions

Use this table to indicate which project versions currently receive security maintenance.

| Version | Distribution Channel | Supported |
|---------|----------------------|-----------|
| Latest version (master branch) | GitHub (source) | ✅ |
| Preceding versions | Any distribution channel | ❌ |

## 🚨 Reporting a Vulnerability

Please do not disclose suspected vulnerabilities publicly before maintainers have had an opportunity to validate and remediate them.

To report a vulnerability:
- [GitHub Security Advisories](https://github.com/hmlendea/android-debloater/security/advisories)
- Contact the maintainers directly via GitHub Issues

## 📌 Scope

The subsequent report categories are in scope for this repository:
- Command injection or argument injection in the Bash script
- Path traversal or arbitrary file write via temporary APK handling
- Insecure APK download (missing integrity verification, HTTPS downgrade)
- ADB command manipulation leading to unintended device operations
- Information exposure through console output or logs

The subsequent categories are out of scope unless explicitly stated to the contrary:
- Vulnerabilities in the Android operating system or vendor firmware
- Vulnerabilities in the ADB tool (`android-tools-adb`) or platform tools
- Vulnerabilities in upstream APK distribution endpoints (Aurora Store, F-Droid, Fossify, Breezy Weather)
- Issues arising from operator modification of the script
- Physical device access or USB authorisation bypass
- Denial of service via ADB (device becomes unresponsive)

## 📢 Disclosure Policy

This project follows coordinated disclosure:
1. Vulnerabilities are investigated privately.
2. A remediation plan is prepared and validated.
3. Public disclosure is published after a fix, mitigation, or agreed risk decision is available.
4. Credit is attributed in accordance with reporter preference and project policy.

## 🧾 Safe Harbour

If your research is conducted in good faith, confined to authorised scope, and disclosed responsibly, the maintainers will not pursue action for policy-compliant activity.

## 🙏 Recognition

We appreciate responsible disclosure. Reporters who desire public attribution may be acknowledged in release notes, advisories, or a dedicated acknowledgements section.