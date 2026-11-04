# Design Decisions

This document records key architectural and design choices with rationale.

## Decision: Prefer Disable Over Uninstall

**Status**: Accepted
**Date**: Project inception
**Context**: Debloating Android devices carries risk of breaking OTA updates or system functionality.

**Decision**: Default to `pm disable-user` for the vast majority of packages. Reserve `pm uninstall` for a small explicit subset.

**Rationale**:
- Disabled packages can be re-enabled from Settings without ADB
- Disabled packages preserve data and system image integrity
- OTA updates more likely to succeed with disabled vs uninstalled packages
- Uninstall is irreversible without system image or factory reset

**Consequences**:
- Catalogue uses `disable_android_package` for ~290 packages
- Only ~10 packages use `uninstall_android_package`
- Storage space not reclaimed (packages remain on disk)

## Decision: Heuristic Device Classification

**Status**: Accepted
**Date**: Project inception
**Context**: Need to distinguish phones from TVs to gate provisioning.

**Decision**: Check for `com.google.android.tv.remote.service` package presence. If installed → TV, else → Phone.

**Rationale**:
- No formal Android device-type API accessible via ADB
- Package heuristic is lightweight, dependency-free
- TV remote service package reliably present on Android TV devices

**Consequences**:
- Classification accuracy depends on package remaining relevant
- No fallback or confidence scoring
- Misclassification gates provisioning incorrectly

## Decision: Single Script Architecture

**Status**: Accepted
**Date**: Project inception
**Context**: Simplicity vs maintainability trade-off.

**Decision**: Keep all orchestration, helpers, and catalogue in one Bash file.

**Rationale**:
- Zero dependencies beyond standard tools
- Easy to copy, run, modify
- Single file to audit and review

**Consequences**:
- 662-line file with mixed concerns
- No module boundaries or encapsulation
- Change risk concentrated in single file
- No unit testing of helpers in isolation

## Decision: Hard-Coded Package Catalogue

**Status**: Accepted
**Date**: Project inception
**Context**: Package identifiers vary by OEM, ROM, Android version.

**Decision**: Embed ~300 package identifiers as string literals in script.

**Rationale**:
- No external configuration format to parse
- Version control tracks catalogue changes directly
- Simple to edit and review

**Consequences**:
- Catalogue updates require script modification
- No per-device or per-OEM catalogue variants
- No dynamic discovery of installed bloatware

## Decision: Hard-Coded APK URLs

**Status**: Accepted
**Date**: Project inception
**Context**: Provisioning requires specific APK versions.

**Decision**: Embed HTTPS URLs directly in `install_android_package` calls.

**Rationale**:
- No configuration file infrastructure
- URLs stable enough for current providers
- Simple to update when versions change

**Consequences**:
- URLs become stale independently of repository
- No checksum verification
- No fallback mirrors
- Version updates require script edit

## Decision: No `set -euo pipefail`

**Status**: Accepted (implicit)
**Date**: Project inception
**Context**: Bash strict mode would change failure semantics.

**Decision**: Do not enable strict mode; allow best-effort continuation.

**Rationale**:
- Script designed to continue through individual package failures
- Strict mode would exit on first probe failure or command error
- Current behaviour matches "run through entire catalogue" expectation

**Consequences**:
- Unset variables not caught
- Pipeline failures silent
- Error aggregation impossible
- Debugging harder

## Decision: User 0 Only

**Status**: Accepted
**Date**: Project inception
**Context**: Android multi-user support.

**Decision**: All package operations target `--user 0` exclusively.

**Rationale**:
- Primary user is typically user 0
- Simplifies implementation
- Avoids complexity of multi-user orchestration

**Consequences**:
- Does not affect work profiles, secondary users
- Operator must manually target other users if needed

## Decision: No Dry-Run Mode

**Status**: Accepted (implicit)
**Date**: Project inception
**Context**: Safety vs simplicity.

**Decision**: Script executes immediately without preview.

**Rationale**:
- Simpler implementation
- Operator can review catalogue before running
- Recovery commands documented

**Consequences**:
- No safe preview of changes
- Higher risk of accidental modification
- No CI validation of catalogue against device