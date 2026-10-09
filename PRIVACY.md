# Privacy and Personal Data

This document describes how Android Debloater handles personal data. The script is a self-hosted Bash utility that runs on the operator's machine and interacts with a connected Android device through ADB. No data is transmitted to the project maintainers or any external service except for optional APK downloads during phone provisioning.

**Information reviewed:** 2026-10-09

## 📑 Table of Contents

- [What This Document Covers](#what-this-document-covers)
- [Self-Hosted Deployments](#self-hosted-deployments)
- [Data We Handle](#data-we-handle)
- [Processing and Use](#processing-and-use)
- [Storage, Retention, and Deletion](#storage-retention-and-deletion)
- [External Processing and Integrations](#external-processing-and-integrations)
- [Data Protection and Security](#data-protection-and-security)
- [Document Changes](#document-changes)
- [Contact](#contact)

## 🔎 What This Document Covers

This document describes how Android Debloater at https://github.com/hmlendea/android-debloater handles personal data. It covers the application behaviour and verified integrations described below. Where the software is self-hosted, the instance operator may have separate responsibilities described below.

## 🏠 Self-Hosted Deployments

Android Debloater is a self-hosted Bash script. The operator downloads and runs the script on their own machine. The project maintainers do not operate any instance of the software and have no access to operator devices, ADB connections, or Android device data.

The instance operator controls:
- Local storage, logs, and backups on their host machine
- ADB transport and authorisation on the target Android device
- Package selection through script modification
- Retention and deletion of any temporary files created during execution

The script sends no telemetry, crash reports, or usage data to the project maintainers. The only external network activity is optional HTTPS downloads of APK files from verified upstream sources (Aurora Store, F-Droid, Fossify, Breezy Weather) when provisioning alternative applications on phones. Operators can disable provisioning by modifying the script or by running it on a device classified as TV.

## 📥 Data We Handle

### Data Provided to the Application

- ADB device serial numbers and authorisation state (transient, read from `adb devices` output)
- Android package names and enabled/disabled state for user 0 (queried from the device via `adb shell pm list packages`)
- Operator-supplied script modifications (package lists, APK URLs) if the operator edits the script

No personal identifiers, account credentials, or user content are requested or processed by the script.

### Data Generated or Collected by the Application

- Temporary APK files downloaded to the current working directory during phone provisioning (deleted after installation attempt)
- Console output showing package operations (disable, uninstall, install) with package names
- Shell command exit codes and stderr from `adb` and `wget`

No persistent logs, databases, or telemetry are created by the script.

### Data Received from Integrations

- APK binaries from upstream distribution endpoints (Aurora Store, F-Droid, Fossify, Breezy Weather) during phone provisioning
- No personal data is received from any integration or third party

## 🧭 Processing and Use

The application processes the data described above for these verified functions:
- Device detection and classification (Phone vs TV) — ADB device list and package heuristic (`com.google.android.tv.remote.service`)
- Phone provisioning: download and install alternative APKs when absent — package names and HTTPS APK URLs
- Package deactivation: disable or uninstall curated package list — package names from hard-coded catalogue
- Console progress reporting — package names and operation results

## 🗄️ Storage, Retention, and Deletion

| Data Category | Storage Location | Retention | Deletion Control |
|---------------|------------------|-----------|------------------|
| ADB device list | Host memory (transient) | Single invocation | Automatic (process exit) |
| Device package listings | Host memory (transient) | Single invocation | Automatic (process exit) |
| Temporary APK files | Host filesystem (CWD) | Until `adb install` completes | Script removes after install attempt |
| Console output | Host terminal | Operator-controlled | Operator-controlled |
| Android package state (enabled/disabled/installed) | Android device (user 0) | Persistent on device | Operator via `adb shell pm enable`, `pm install-existing`, or device factory reset |

The project maintainers do not store, retain, or access any of the above data. The instance operator controls all local storage and the Android device state.

## 🔗 External Processing and Integrations

| Service or integration | Purpose | Data involved | Configuration or documentation |
|-----------------------|---------|---------------|--------------------------------|
| Aurora Store (auroraoss.com) | Alternative app store APK | Package name `com.aurora.store` | Hard-coded URL in script |
| F-Droid (f-droid.org) | Alternative app store APK | Package name `org.fdroid.fdroid` | Hard-coded URL in script |
| Fossify (fossify.org) | Alternative apps (Gallery, Keyboard, etc.) | Package names `org.fossify.*` | Hard-coded URLs in script |
| Breezy Weather (breezyweather.app) | Alternative weather app APK | Package name `com.breezyweather.app` | Hard-coded URL in script |

The script downloads APKs over HTTPS using `wget --continue`. No authentication, API keys, or personal data are sent to these services. The operator can disable provisioning by editing the script or by ensuring the target device is classified as TV.

## 🛡️ Data Protection and Security

- The script runs with the operator's user privileges on the host machine
- ADB communication uses the existing authorised USB/transport connection; the script does not manage ADB keys or authorisation
- Temporary APK files are written to the current working directory and removed after installation attempt; no checksum verification is implemented
- The operator is responsible for:
  - Host OS updates and Bash/`adb`/`wget` security patches
  - ADB authorisation management on the target device
  - Network exposure of the host machine
  - Reviewing hard-coded APK URLs before execution
  - Backups of Android device state before running the script

No encryption, access controls, or audit logging are implemented by the script. The project does not promise absolute security.

## 🔄 Document Changes

Update this document when application data flows, storage, integrations, or deployment responsibilities change. The current version is published at https://github.com/hmlendea/android-debloater/blob/master/PRIVACY.md.

## 📬 Contact

For questions about application data handling, contact the project maintainers at https://github.com/hmlendea/android-debloater/issues. For a self-hosted instance, contact the instance operator, unless the project explicitly handles the request. Include the script version or commit hash and the target device type (Phone/TV) if relevant; do not send passwords, access tokens, ADB keys, or other secrets.