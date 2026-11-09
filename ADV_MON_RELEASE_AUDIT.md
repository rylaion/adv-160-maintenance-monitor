# ADV-MON — Complete System Audit, Testing & Android APK Release Report

**Audit Date:** 2026-11-09 (Asia/Manila)  
**Application:** ADV-MON — Honda ADV 160 Maintenance Monitor  
**Package ID:** `com.advmon.adv_mon`  
**Version:** `0.1.0+1` (`versionName: 0.1.0`, `versionCode: 1`)  
**Database Schema Version:** `v4` (`kDatabaseSchemaVersion = 4`)

---

## 1. Project Overview

**ADV-MON** is a 100% offline-first Flutter Android application designed for Honda ADV 160 (2023 Philippines model) owners to track odometer readings, evaluate manufacturer-prescribed and user-defined maintenance schedules, log service history with parts and inspection photos, monitor physical component wear/measurements, schedule local reminders, analyze maintenance expenses, and export/restore full offline backups.

- **Architecture:** Feature-first layered architecture (`data`, `domain`, `presentation`) powered by Riverpod (`flutter_riverpod`), `go_router`, and Drift (`drift` + `sqlite3_flutter_libs`) over local SQLite.
- **Offline Guarantee:** The application does not request `android.permission.INTERNET` in `AndroidManifest.xml`; all data is stored locally in the application documents directory (`adv_mon.sqlite`, `attachments/`, `exports/`, `adv_mon_settings.json`).

---

## 2. Features Inspected

| Module / Feature | Primary Files Inspected | Status |
|---|---|---|
| Project & Android Build Configuration | `pubspec.yaml`, `android/app/build.gradle`, `android/settings.gradle`, `android/app/src/main/AndroidManifest.xml` | **PASS** |
| Drift SQLite Database & Migrations (`v1` → `v4`) | `lib/core/database/app_database.dart`, `lib/core/database/tables/*.dart`, `lib/core/database/migrations/migrations.dart` | **PASS** |
| Initial Seed & 2023 Honda ADV160 Schedule Seed | `lib/core/database/seed/initial_seed.dart`, `lib/core/database/seed/honda_schedule_seed.dart` | **PASS** |
| Motorcycle Profile Management | `lib/features/motorcycle/data/motorcycle_repository.dart`, `motorcycle_profile_screen.dart`, `motorcycle_edit_screen.dart` | **PASS** |
| Odometer Tracking & Correction Audit Trail | `lib/core/services/odometer_service.dart`, `lib/features/odometer/data/odometer_repository.dart`, `odometer_screen.dart` | **PASS** |
| Maintenance Calculation Engine & Inspection Guide | `lib/core/services/maintenance_calculator.dart`, `lib/features/maintenance/domain/maintenance_overview.dart`, `maintenance_screen.dart`, `dashboard_screen.dart` | **PASS** |
| Maintenance Records, Parts & Attachments | `lib/features/maintenance/data/maintenance_repository.dart`, `maintenance_form_screen.dart`, `maintenance_history_screen.dart`, `parts_repository.dart`, `parts_screen.dart` | **PASS** |
| Component Measurements & Trend Charts | `lib/features/components/data/components_repository.dart`, `components_screen.dart`, `component_detail_screen.dart` | **PASS** |
| Local Reminders & Background Worker | `lib/features/reminders/data/reminders_repository.dart`, `notification_service.dart`, `background_worker.dart`, `reminders_screen.dart` | **PASS** |
| Expense Reports, CSV Export & Backup/Restore | `lib/core/services/expense_service.dart`, `lib/core/services/backup_service.dart`, `reports_screen.dart`, `settings_screen.dart` | **PASS** |

---

## 3. Phase 1 Test Results (Core Setup, Motorcycle Profile & Navigation)

| Verification Item | Result | Notes |
|---|---|---|
| Motorcycle profile default seed (`Honda ADV 160`, `2023`) | **PASS** | Verified in `test/database/app_database_test.dart` (`seeds ADV 160 motorcycle`). |
| Motorcycle profile editing & validation | **PASS** | Verified in `test/unit/motorcycle_validator_test.dart` and `app_database_test.dart` (`motorcycle repository updates profile`). |
| Motorcycle profile display | **PASS** | Displays brand, model, model year, plate/chassis/engine numbers, purchase date, photo, and current odometer. |
| 8 maintenance categories & 26 items seeded | **PASS** | `Engine`, `Fuel System`, `CVT / Transmission`, `Braking System`, `Cooling System`, `Electrical / Battery`, `Tires / Wheels`, `Chassis / Suspension`. |
| Dashboard loading & 5-tab navigation shell | **PASS** | Verified via `StatefulShellRoute.indexedStack` (`Dashboard`, `Maintenance`, `Components`, `Reports`, `Settings`) and widget tests. |
| Database persistence & foreign key enforcement | **PASS** | `PRAGMA foreign_keys = ON` verified in `beforeOpen`; tested against invalid deletes. |

---

## 4. Phase 2 Test Results (Odometer & Maintenance Calculation Engine)

| Verification Item | Result | Notes |
|---|---|---|
| Manual odometer entry & zero/first reading | **PASS** | Verified in `test/database/phase2_test.dart`. |
| Negative odometer & future date rejection | **PASS** | Checked at both service layer (`OdometerService`) and SQLite `CHECK (reading_km >= 0)` constraint. |
| Odometer regression protection | **PASS** | Rejects readings lower than latest confirmed reading; accepts equal or higher readings. |
| Odometer correction with audit trail | **PASS** | Marks old row `CORRECTED`, inserts new `CONFIRMED` row with `supersedesLogId` and `correctionReason`, and recalculates maintenance statuses. |
| Mileage-based, date-based & combined schedules | **PASS** | Verified in `test/unit/maintenance_calculator_test.dart` and `test/database/inspection_guide_test.dart`. |
| Recurring maintenance intervals (`> 36,000 km`) | **PASS** | Verified at `41,600 km`, `42,000 km`, `48,000 km`, `54,000 km`, and `60,000 km`. |
| `UPCOMING`, `DUE`, `OVERDUE`, `COMPLETED`, `GOOD` | **PASS** | All boundary checkpoints tested (`11,500 km`, `12,000 km`, `12,500 km`, `18,000 km`, `20,000 km`, `23,500 km`). |
| Odometer updates preserve maintenance history | **PASS** | Updating odometer never deletes or completes maintenance records automatically. |

---

## 5. Phase 3 Test Results (Maintenance Records, Parts, Measurements & Attachments)

| Verification Item | Result | Notes |
|---|---|---|
| Create, edit (versioned), and void maintenance records | **PASS** | Editing voids the superseded record (`voidedAt` + `supersedesRecordId`) so history is never overwritten. |
| Service notes, completion odometer & service date | **PASS** | Higher service odometer automatically logs a confirmed odometer entry in the same transaction. |
| Parts catalog & part installation lifecycle | **PASS** | Installing a replacement part automatically closes the previously installed part at the same position (`FRONT`/`REAR`). |
| Component measurements & condition observations | **PASS** | Supports numeric (`mm`, `V`, `kPa`) and condition-only observations without inventing unverified wear limits. |
| Photo attachments copy & rollback safety | **PASS** | `AttachmentService` copies photos into app storage and cleans up copies if the DB transaction fails. |
| Completing a task updates only the matching item | **PASS** | Completing `Air Cleaner` at `18,000 km` advances `Air Cleaner` to `36,000 km` while leaving unrelated `18,000 km` items due/overdue. |

---

## 6. Phase 4 Test Results (Reminders, Notifications & Expenses/Reports)

| Verification Item | Result | Notes |
|---|---|---|
| Offline notification gateway & initialization | **PASS** | Verified via `FakeNotificationsGateway` in `test/database/phase4_test.dart`. |
| Android 13+ permission handling | **PASS** | `POST_NOTIFICATIONS` declared in manifest; `requestNotificationsPermission()` wired in `FlutterLocalNotificationsGateway`. |
| Deduplication via `dedupe_key` (`UNIQUE`) | **PASS** | Repeated `syncReminders()` calls do not emit duplicate notifications. |
| Auto-resolution when maintenance is recorded | **PASS** | Completing a due/overdue service cancels the notification and marks the reminder `DISMISSED`. |
| Date-based reminder scheduling (`Asia/Manila`) | **PASS** | Schedules via `zonedSchedule` (`AndroidScheduleMode.inexactAllowWhileIdle`). |
| Monthly, annual, category, parts vs. labor & cost/km reports | **PASS** | Verified in `test/unit/expense_service_test.dart` and `test/database/phase4_test.dart`. |

---

## 7. Phase 5 Test Results (Backup, Restore, CSV Export & Settings)

| Verification Item | Result | Notes |
|---|---|---|
| Full JSON backup of all 13 tables | **PASS** | Verified in `test/database/phase5_test.dart`. |
| ZIP backup bundling `backup.json` + photo attachments | **PASS** | Pure-Dart `ZipCodec` (STORED + DEFLATE with CRC-32 verification). |
| Pre-restore structure, version & FK validation | **PASS** | Rejects corrupted archives, unsupported schema versions, missing tables, and broken foreign keys before touching data. |
| Atomic transactional restore with user confirmation | **PASS** | Requires `confirmedByUser: true` and preserves all original primary/foreign keys. |
| RFC-4180 CSV exports (Maintenance Records & Expenses) | **PASS** | Verified in `test/database/phase5_test.dart`. |

---

## 8. Phase 6 Test Results (Odometer-Based Maintenance Inspection Guide)

| Verification Item | Result | Notes |
|---|---|---|
| Dashboard Next Major Maintenance Checkpoint card | **PASS** | Shows next applicable checkpoint km, remaining km, and counts of `Inspect (I)`, `Replace (R)`, and `Clean (C)` tasks. |
| Dashboard Overdue, Due, Upcoming & Recently Completed | **PASS** | Distinct sections rendered and verified in `test/widget/phase5_widget_test.dart`. |
| Maintenance Screen `By Category` & `Inspection Guide` tabs | **PASS** | Milestone filter chips (`1,000 km` to `36,000+ km`) and one-tap `Complete` action pre-filling item, action, and checkpoint km. |

---

## 9. Honda Maintenance Schedule Verification

Verified against the official **2023 Honda ADV160 Philippines Owner's Manual** (`32K0WA100`, pages 87–89):

| # | Item | Category | Action(s) | Official Checkpoints (`32K0WA100`) | Recurrence (`*1`) | Source Page | Status |
|---|---|---|---|---|---|---|---|
| 1 | `Fuel Line` | Fuel System | `I` | `12k, 18k, 24k, 30k, 36k km` | Every `6,000 km` from `12,000 km` | p. 88 | **PASS** |
| 2 | `Throttle Operation` | Fuel System | `I` | `6k, 12k, 18k, 24k, 30k, 36k km` | Every `6,000 km` | p. 88 | **PASS** |
| 3 | `Air Cleaner` (`*2`) | Fuel System | `R` | `18k, 36k km` | Every `18,000 km` | p. 88 | **PASS** |
| 4 | `Crankcase Breather` (`*3`) | Engine | `C` | `6k, 12k, 18k, 24k, 30k km` | Every `6,000 km` | p. 88 | **PASS** |
| 5 | `Spark Plug` | Engine | `I` / `R` | `I`: `6k, 18k, 30k km`; `R`: `12k, 24k, 36k km` | `I` every `12k` (from `6k`); `R` every `12k` | p. 88 | **PASS** |
| 6 | `Valve Clearance` | Engine | `I` | `6k, 12k, 18k, 24k, 30k km` | Every `6,000 km` | p. 88 | **PASS** |
| 7 | `Engine Oil` | Engine | `R` | `1k, 6k, 12k, 18k, 24k, 30k, 36k km` | Initial `1,000 km`, then every `6,000 km` | p. 88 | **PASS** |
| 8 | `Engine Oil Strainer Screen` | Engine | `C` | `6k, 18k, 30k km` | Every `12,000 km` from `6,000 km` | p. 88 | **PASS** |
| 9 | `Engine Idle Speed` | Engine | `I` | `1k, 6k, 12k, 18k, 24k, 30k, 36k km` | Initial `1,000 km`, then every `6,000 km` | p. 88 | **PASS** |
| 10 | `Radiator Coolant` (`*4`) | Cooling System | `I` / `R` | `I`: `6k, 18k, 30k, 36k km`; `R`: Every `3 Years` (`36 mo`) | `I` repeats every `12k` after `36k`; `R` every `36 mo` | p. 88 | **PASS** |
| 11 | `Cooling System` | Cooling System | `I` | `6k, 18k, 30k, 36k km` | Repeats every `12,000 km` after `36,000 km` | p. 88 | **PASS** |
| 12 | `Drive Belt` | CVT / Transmission | `I` / `R` | `I`: `12k, 36k km`; `R`: `24k km` | `I` every `24k` (from `12k`); `R` every `24k` | p. 89 | **PASS** |
| 13 | `Final Drive Oil` (`*4`) | CVT / Transmission | `R` | Every `2 Years` (`24 months`) | Every `24 months` | p. 89 | **PASS** |
| 14 | `Battery` | Electrical / Battery | `I` | `6k, 12k, 18k, 24k, 30k, 36k km` | Every `6,000 km` | p. 89 | **PASS** |
| 15 | `Brake Fluid` (`*4`) | Braking System | `I` / `R` | `I`: `6k..36k km`; `R`: Every `2 Years` (`24 months`) | `I` every `6,000 km`; `R` every `24 months` | p. 89 | **PASS** |
| 16 | `Brake Pads Wear` | Braking System | `I` | `6k, 12k, 18k, 24k, 30k, 36k km` | Every `6,000 km` | p. 89 | **PASS** |
| 17 | `Brake System` | Braking System | `I` | `1k, 6k, 12k, 18k, 24k, 30k, 36k km` | Initial `1,000 km`, then every `6,000 km` | p. 89 | **PASS** |
| 18 | `Headlight Aim` | Electrical / Battery | `I` | `6k, 12k, 18k, 24k, 30k, 36k km` | Every `6,000 km` | p. 89 | **PASS** |
| 19 | `Lights/Horn` | Electrical / Battery | Pre-ride | Pre-ride inspection item (pp. 89–90) | Pre-ride check (no mileage/month interval) | p. 89 | **PASS** |
| 20 | `Clutch Shoes Wear` | CVT / Transmission | `I` | `12k, 24k, 36k km` | Every `12,000 km` | p. 89 | **PASS** |
| 21 | `Side Stand` | Chassis / Suspension | `I` | `6k, 12k, 18k, 24k, 30k, 36k km` | Every `6,000 km` | p. 89 | **PASS** |
| 22 | `Suspension` | Chassis / Suspension | `I` | `6k, 12k, 18k, 24k, 30k, 36k km` | Every `6,000 km` | p. 89 | **PASS** |
| 23 | `Nuts, Bolts, Fasteners` | Chassis / Suspension | `I` | `1k, 12k, 24k, 36k km` | Initial `1,000 km`, then every `12,000 km` | p. 89 | **PASS** |
| 24 | `Wheels/Tyres` | Tires / Wheels | `I` | `6k, 12k, 18k, 24k, 30k, 36k km` | Every `6,000 km` | p. 89 | **PASS** |
| 25 | `Steering Head Bearings` | Chassis / Suspension | `I` | `12k, 24k, 36k km` | Every `12,000 km` | p. 89 | **PASS** |
| 26 | `Fuel Filter` | Fuel System | Custom | Explicitly labeled as user-defined task (no Honda rule) | User-configurable custom interval | N/A | **PASS** |

---

## 10. Database and Migration Results

- **Tables Verified (13/13):** `motorcycles`, `maintenance_categories`, `maintenance_items`, `maintenance_rules`, `maintenance_rule_steps`, `maintenance_records`, `odometer_logs`, `component_measurements`, `parts`, `maintenance_record_parts`, `part_installations`, `maintenance_reminders`, `attachments`.
- **Indexes Verified:** 15 `idx_*` indexes covering foreign keys and frequent query columns.
- **Migrations Tested:**
  - `v1 → v2`: Seeds verified Honda schedule rules (`test/database/phase2_test.dart`).
  - `v2 → v3`: Adds `supersedes_record_id` to `maintenance_records` and `voided_at` to `component_measurements` while preserving existing rows (`test/database/phase3_test.dart`).
  - `v3 → v4`: Renames legacy category/item names in place (preserving primary keys and foreign keys) and seeds all 8 categories, 26 items, and 28 verified Honda manual rules (`test/database/inspection_guide_test.dart`).
  - Downgrade rejection (`from > to`) throws `StateError`.

---

## 11. Flutter Analyzer Results

Command executed: `flutter analyze`

```text
Analyzing adv-mon...
No issues found! (ran in 5.7s)
```

- **Status:** **PASS** (0 errors, 0 warnings, 0 lints).

---

## 12. Automated Test Results

Command executed: `flutter test`

| Test Suite | Passed | Failed | Skipped | Status |
|---|---|---|---|---|
| `test/database/app_database_test.dart` | 12 | 0 | 0 | **PASS** |
| `test/database/inspection_guide_test.dart` | 12 | 0 | 0 | **PASS** |
| `test/database/phase2_test.dart` | 26 | 0 | 0 | **PASS** |
| `test/database/phase3_test.dart` | 14 | 0 | 0 | **PASS** |
| `test/database/phase4_test.dart` | 9 | 0 | 0 | **PASS** |
| `test/database/phase5_test.dart` | 9 | 0 | 0 | **PASS** |
| `test/unit/expense_service_test.dart` | 2 | 0 | 0 | **PASS** |
| `test/unit/maintenance_calculator_test.dart` | 44 | 0 | 0 | **PASS** |
| `test/unit/motorcycle_validator_test.dart` | 2 | 0 | 0 | **PASS** |
| `test/widget/phase3_widget_test.dart` | 5 | 0 | 0 | **PASS** |
| `test/widget/phase4_widget_test.dart` | 1 | 0 | 0 | **PASS** |
| `test/widget/phase5_widget_test.dart` | 3 | 0 | 0 | **PASS** |
| **TOTAL** | **139** | **0** | **0** | **PASS** |

---

## 13. Bugs Discovered

1. **`android/app/build.gradle` (Line 61) — Release Build Failure (`kotlinOptions` Scope):** `kotlinOptions { jvmTarget = "17" }` was placed at the root project level outside the `android { ... }` block, causing `flutter build apk --release` to fail with `Could not find method kotlinOptions() on project ':app'`.
2. **`lib/features/reminders/data/reminders_repository.dart` (Line 229) — Non-exhaustive Switch Expression:** Adding `MaintenanceStatus.completed` caused a compile-time non-exhaustive `switch (ruleEval.status)` in `RemindersRepository.syncReminders()`.
3. **`lib/features/maintenance/presentation/maintenance_screen.dart` (Line 268) — `RenderFlex` Bottom Overflow (5.0 px):** `_CheckpointTaskTile` placed a `Column` (`StatusChip` + `Complete` button) inside `ListTile.trailing`, which is constrained to `maxHeight: 56.0`, causing a 5.0 px vertical overflow.
4. **`lib/features/settings/presentation/settings_screen.dart` (Line 169) — Threshold Dialog Validation & Fallback Defaults:** The reminder thresholds dialog lacked input validation for negative numbers and fell back to `dueThresholdKm: 100` / `upcomingThresholdKm: 1000` instead of the app's configured defaults (`dueThresholdKm: 0`, `upcomingThresholdKm: 500`).
5. **`android/app/src/main/AndroidManifest.xml` (Lines 4–6) — App Label & Unnecessary Exact Alarm Permission:** `android:label` was set to `"adv_mon"` instead of `"ADV-MON"`, and `android.permission.SCHEDULE_EXACT_ALARM` was declared even though `NotificationService` uses `AndroidScheduleMode.inexactAllowWhileIdle`.
6. **`lib/features/motorcycle/presentation/motorcycle_edit_screen.dart` (Line 56) — Direct `ImagePicker` & `DateTime.now()` Usage:** Bypassed `photoPickerProvider` (skipping image sizing/compression and testability) and `clockProvider`.

---

## 14. Bugs Fixed

1. **Fixed `android/app/build.gradle`:** Moved `kotlinOptions { jvmTarget = "17" }` inside the `android { ... }` block; release APK compilation succeeded cleanly.
2. **Fixed `lib/features/reminders/data/reminders_repository.dart`:** Handled `MaintenanceStatus.completed` alongside `MaintenanceStatus.good` in `syncReminders()`.
3. **Fixed `lib/features/maintenance/presentation/maintenance_screen.dart`:** Replaced the constrained `ListTile.trailing` in `_CheckpointTaskTile` with a custom `Padding` + `Row` layout, eliminating the `RenderFlex` overflow.
4. **Fixed `lib/features/settings/presentation/settings_screen.dart`:** Added form validation (`>= 0` and `upcoming >= due`) and aligned fallback defaults to `0 km` / `500 km` / `7 days` / `30 days`.
5. **Fixed `android/app/src/main/AndroidManifest.xml`:** Updated `android:label="ADV-MON"` and removed the unused `android.permission.SCHEDULE_EXACT_ALARM` permission.
6. **Fixed `lib/features/motorcycle/presentation/motorcycle_edit_screen.dart`:** Wired `photoPickerProvider` and `clockProvider` (`AppDates.todayManila`).

---

## 15. Remaining Issues

- **No release-blocking functional or code issues remain.**
- **Advisory / Non-blocking Build Notes:**
  1. **Production Keystore Signing:** No production keystore (`key.properties` / `.jks`) is present in the workspace. As required by Part 13, no keystore was invented; `buildTypes.release` uses `signingConfigs.debug` (`CN=Android Debug`). Before publishing to Google Play or distributing seamless production updates, configure a dedicated release keystore.
  2. **Plugin Compile SDK Advisory:** Gradle emits an advisory warning that `sqlite3_flutter_libs` recommends `compileSdk 35` and NDK `25.1.8937393` (currently building with Flutter's `compileSdk 34`). The release APK compiles, links, and verifies cleanly.

---

## 16. Release Configuration

| Property | Value | Status |
|---|---|---|
| Application Name (`android:label`) | `ADV-MON` | **PASS** |
| Application ID (`applicationId` / `namespace`) | `com.advmon.adv_mon` | **PASS** |
| Version Name / Version Code | `0.1.0` / `1` (`0.1.0+1`) | **PASS** |
| Minimum SDK (`minSdk`) | `23` (Android 6.0 Marshmallow) | **PASS** |
| Target SDK (`targetSdk`) / Compile SDK | `34` (Android 14) | **PASS** |
| Debug Banner (`debugShowCheckedModeBanner`) | `false` | **PASS** |
| Launcher Icon | `@mipmap/ic_launcher` (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`) | **PASS** |
| Declared Manifest Permissions | `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED` (no `INTERNET` permission) | **PASS** |

---

## 17. APK Build Status

- **Status:** **PASS**
- **Command:** `flutter build apk --release` (after `flutter clean`, `flutter pub get`, `flutter analyze`, `flutter test`)

---

## 18. APK Output Location

- **Relative Path:** `build/app/outputs/flutter-apk/app-release.apk`
- **Absolute Path:** `c:\xampp2\htdocs\adv-mon\build\app\outputs\flutter-apk\app-release.apk`

---

## 19. APK File Size

- **Exact Size:** `60,030,029 bytes` (`57.25 MiB` / `60.03 MB`)

---

## 20. Application ID and Version

Verified via Android SDK `aapt dump badging`:

```text
package: name='com.advmon.adv_mon' versionCode='1' versionName='0.1.0' platformBuildVersionName='14' platformBuildVersionCode='34' compileSdkVersion='34' compileSdkVersionCodename='14'
sdkVersion:'23'
targetSdkVersion:'34'
application-label:'ADV-MON'
launchable-activity: name='com.advmon.adv_mon.MainActivity'
```

---

## 21. Signing Status

Verified via Android SDK `apksigner verify --verbose --print-certs`:

- **Signing Status:** **Installable Release APK signed with Android Debug Keystore (`signingConfigs.debug`)** — **PASS (Temporary/Debug Signing Explicitly Documented per Part 13)**
- **v1 Scheme (JAR Signing):** `true`
- **v2 Scheme (APK Signature Scheme v2):** `true`
- **Signer #1 Certificate DN:** `C=US, O=Android, CN=Android Debug`
- **Signer #1 Certificate SHA-256 Digest:** `44207d38dafd5b940c3584006d00aa759bd5b2121b73157ef91bb6d0abd98aab`
- **Signer #1 Key Algorithm:** `RSA` (`2048 bits`)
- **Important Upgrade Notice:** Because this APK is signed with the local debug keystore (`CN=Android Debug`), it can be installed directly on Android devices for testing and personal use, but **cannot** be used as a seamless in-place update over a future installation signed with a different production keystore (Android requires uninstalling the debug-signed package before installing a differently signed production build).

---

## 22. SHA-256 Checksum

- **File:** `c:\xampp2\htdocs\adv-mon\build\app\outputs\flutter-apk\app-release.apk`
- **SHA-256:** `5C9CC2F9CFEF522CC58013C1720107B617B9EAA6256C06905962AA22DE253A99`

---

## 23. Physical Device Test Results

- **Status:** **NOT TESTED** (No physical Android device or Android emulator was attached to the workstation during the audit; `flutter devices` detected only `Windows`, `Chrome`, and `Edge`).
- Local notification scheduling, permissions, database persistence, and UI flows were verified via automated integration/widget tests; physical device notification delivery and boot receiver behavior must be verified on an Android handset after installing the APK.

---

## 24. Final Release Recommendation

- **Overall Audit & Build Status:** **PASS** (for local/sideloaded release APK deployment; production Play Store signing requires a production `.jks` keystore).
- **Summary:** All 13 database tables, `v1 → v4` migrations, the official 2023 Honda ADV160 (`32K0WA100`, pp. 87–89) maintenance schedule, the Odometer-Based Maintenance Inspection Guide, maintenance history, parts lifecycle, component measurements, expense reports, offline backups, static analysis (`0 issues`), and all **139 automated tests** passed.

### Installation Instructions (Android Device)

1. **Via ADB (USB Debugging enabled):**
   ```powershell
   adb install -r "c:\xampp2\htdocs\adv-mon\build\app\outputs\flutter-apk\app-release.apk"
   ```
2. **Via Direct File Transfer (Sideloading):**
   - Copy `c:\xampp2\htdocs\adv-mon\build\app\outputs\flutter-apk\app-release.apk` to your Android phone.
   - Verify the SHA-256 checksum matches `5C9CC2F9CFEF522CC58013C1720107B617B9EAA6256C06905962AA22DE253A99`.
   - Open the `.apk` file on your device and allow installation from your file manager if prompted.
   - On first launch, tap the bell icon in **Reminders & Notifications** to grant Android 13+ notification permission if desired, and enter your current odometer reading on the **Dashboard**.

