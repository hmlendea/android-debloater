# Concurrency and Scheduling

## Execution Model

**Strictly sequential, single-threaded, synchronous.**

```
main()
  ├─ probe_devices()          → blocks
  ├─ classify_device()        → blocks
  ├─ provision_phone()        → blocks (if Phone)
  │    ├─ install_aurora()    → blocks
  │    ├─ install_fdroid()    → blocks
  │    └─ ... (14 total)      → blocks each
  └─ debloat_catalogue()      → blocks
       ├─ disable_batch_1()   → blocks
       ├─ disable_batch_2()   → blocks
       └─ ... (~300 total)    → blocks each
```

## Concurrency Primitives

| Primitive | Used? | Notes |
|-----------|-------|-------|
| Background jobs (`&`) | No | |
| `wait` | No | |
| Subshells | No | |
| Coprocesses | No | |
| Named pipes | No | |
| `flock` | No | |
| GNU Parallel | No | |

## Scheduling

| Aspect | Behaviour |
|--------|-----------|
| Order | Top-to-bottom as written in script |
| Preemption | None (no signals handled) |
| Priorities | None |
| Timeouts | None (commands run to completion) |
| Retries | None (except `wget --continue`) |

## Resource Contention

| Resource | Contention | Resolution |
|----------|------------|------------|
| ADB connection | Single serialised user | Sequential by design |
| Network (APK downloads) | Sequential per-package | `wget --continue` resumes |
| Host filesystem (temp APKs) | Single file at a time | Sequential, unique names |
| Device package manager | Single client | ADB serialises |

## Parallelism Opportunities (Not Implemented)

| Opportunity | Complexity | Benefit |
|-------------|------------|---------|
| Parallel package probes | Low | Faster classification |
| Parallel disable calls | Medium | ~300 ADB round-trips |
| Parallel APK downloads | Medium | 14 concurrent downloads |
| Multi-device support | High | Operate on multiple devices |

## Why No Concurrency

1. **Simplicity** — Single-threaded logic is trivial to audit
2. **ADB serialisation** — ADB server serialises commands anyway
3. **Failure isolation** — Sequential makes failure attribution obvious
4. **No dependency tracking** — Packages independent; no DAG needed
5. **Operator expectation** — Visible progress in console order

## Signal Handling

| Signal | Handler | Behaviour |
|--------|---------|-----------|
| SIGINT (Ctrl+C) | None | Immediate termination, temp APK may remain |
| SIGTERM | None | Immediate termination |
| SIGHUP | None | Immediate termination |
| EXIT | None | No cleanup trap |

**Recommendation**: Add `trap 'rm -f *.apk' EXIT` for temp file cleanup on interruption.