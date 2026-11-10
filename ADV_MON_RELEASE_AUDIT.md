# ADV-MON — Release 0.3.0 Audit, Testing & Android APK Release Report

**Release Date:** 2026-11-10 (Asia/Manila)  
**Application:** ADV-MON — Honda ADV 160 Maintenance Monitor  
**Package ID:** `com.advmon.adv_mon`  
**Version:** `0.3.0+4` (`versionName: 0.3.0`, `versionCode: 4`)  
**Database Schema Version:** `v9` (`kDatabaseSchemaVersion = 9`)  
**Target Platform:** Android (minSdk 24, compileSdk 36, targetSdk 34)

---

## 1. Release Overview

**ADV-MON Release 0.3.0** introduces a comprehensive GPS-based motorcycle navigation and trip recording system inspired by Waze and Google Maps, tailored specifically for the Honda ADV 160. Built entirely with open-source mapping technologies and offline-first capabilities:

- **Interactive OpenStreetMap Navigation:** `flutter_map` rendering with OSM Standard, OLED Night Ride Dark Matter, Day Voyager, and OpenTopoMap tile providers.
- **Sub-400cc Expressway Avoidance Routing:** Custom motorcycle routing profiles automatically avoiding legally restricted Philippine tollways (Skyway, SLEX, NLEX, CALAX, SCTEX per RA 2000).
- **Helmet Voice Navigation:** `flutter_tts` speech guidance with 4-second stutter deduplication, mute controls, and distance countdown (300m / 100m / now).
- **Off-Route Detection & Auto-Reroute:** Continuous polyline distance monitoring triggering recalculation when deviating >45 meters over 3 consecutive GPS fixes.
- **Interactive Route Replay & Speed Telemetry:** Trip history map replay with 1x/2x/5x/10x multipliers, rotating directional marker, and `fl_chart` speed-over-time graphs.
- **Offline MBTiles Storage:** Direct SQLite `.mbtiles` raster tile reader translating Slippy XYZ to TMS coordinates, with strict OSM Tile Usage Policy enforcement.
- **Cockpit Battery Optimization:** Speed-adaptive distance sampling, mountain hairpin apex preservation (>18° turn), and OLED dark matter display saver.
- **OEM Parts & CVT Manager:** Full 2023 Honda ADV 160 exploded diagram parts catalogue and multi-parameter CVT tuning configurations.

---

## 2. Verification & Test Suite Summary

- **Total Automated Tests:** 82 tests
- **Passing Tests:** 82/82 (100% pass rate)
- **Static Analysis:** `flutter analyze` — 0 issues found (0 errors, 0 warnings, 0 lints)
- **Code Formatting:** `dart format .` — 100% compliant

| Test Category | Test File | Test Count | Result |
|---|---|:---:|:---:|
| Database Migrations & Enhancements | `test/database/enhancement_database_test.dart` | 13 | PASS |
| End-to-End Cross-Module Integration | `test/unit/cross_module_integration_test.dart` | 1 | PASS |
| CVT Configuration Manager | `test/unit/cvt_repository_test.dart` | 7 | PASS |
| OEM Parts Catalogue & Exploded Diagrams | `test/unit/parts_catalog_repository_test.dart` | 6 | PASS |
| Trip Recording & SQLite Waypoint Storage | `test/unit/trip_recording_waypoint_storage_test.dart` | 9 | PASS |
| Route Planning & Geocoding | `test/unit/route_planning_and_geocoding_test.dart` | 19 | PASS |
| Turn-by-Turn Navigation & Voice Guidance | `test/unit/turn_by_turn_navigation_test.dart` | 7 | PASS |
| Route Replay & Speed Telemetry Graph | `test/unit/trip_history_replay_test.dart` | 6 | PASS |
| Offline MBTiles Mapping & OSM Policy | `test/unit/offline_mapping_test.dart` | 5 | PASS |
| Battery Optimization & Resilience | `test/unit/battery_optimization_and_resilience_test.dart` | 4 | PASS |
| Trips Repository & Migration | `test/unit/trips_repository_test.dart` | 4 | PASS |
| Dashboard & Maintenance UI | `test/widget/dashboard_and_detail_widget_test.dart` | 1 | PASS |

---

## 3. Build Artifacts

| Build Type | Output Path | Size |
|---|---|:---:|
| Debug APK | `build/app/outputs/flutter-apk/app-debug.apk` | ~85 MB |
| Release APK | `build/app/outputs/flutter-apk/app-release.apk` | **63.9 MB** |

