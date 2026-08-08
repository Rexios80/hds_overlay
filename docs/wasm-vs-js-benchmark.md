# Flutter web: WASM vs non-WASM resource usage

**Date:** 2026-08-08  
**Conclusion:** For the heart-rate overlay workload, **WASM used more CPU** (~1.7× total) with no meaningful memory savings. Prefer the non-WASM build for production/browser sources.

## What was compared

| Build                            | Site                 | Notes          |
| -------------------------------- | -------------------- | -------------- |
| Non-WASM (`dart2js` + CanvasKit) | https://hds.dev      | Production     |
| WASM (`dart2wasm` + skwasm)      | https://beta.hds.dev | Testing / beta |

Non-WASM Flutter web still uses CanvasKit (Skia compiled to Wasm) for rendering. The `--wasm` flag mainly compiles the Dart app itself to Wasm.

## Method

- Dedicated Chrome profile per build (`--user-data-dir`, `--disable-extensions`, remote debugging)
- Live sites (not local `flutter run`)
- Heart-rate animation driven by a real watch session (main CPU hog)
- 60 one-second samples of Chrome process-tree CPU `%` and RSS (browser + renderer + GPU helpers)

## Results (60s averages)

| Metric           | Non-WASM |    WASM | WASM / non-WASM |
| ---------------- | -------: | ------: | --------------: |
| Avg total CPU    |    59.5% |  103.7% |       **1.74×** |
| Max total CPU    |    69.1% |  120.4% |           1.74× |
| Avg renderer CPU |    33.6% |   85.7% |       **2.55×** |
| Avg GPU CPU      |    25.1% |   16.1% |           0.64× |
| Avg total RSS    |  1176 MB | 1168 MB |           ~1.0× |
| Max total RSS    |  1223 MB | 1194 MB |           ~1.0× |
| Avg renderer RSS |   578 MB |  564 MB |           ~1.0× |
| Avg GPU RSS      |   140 MB |  144 MB |           ~1.0× |

The WASM cost is almost entirely in the **renderer** process. GPU CPU was slightly lower on WASM; memory was effectively a wash.

## Decision

Do **not** switch production (`hds.dev`) to WASM for resource-efficiency reasons. Revisit if Flutter’s Wasm / skwasm path improves for continuous animation workloads.
