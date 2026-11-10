# ADV-MON Enhancement & Bug-Fix Report

**Project:** ADV 160 Maintenance Monitor (`adv_mon`)  
**Target Motorcycle:** 2023 Honda ADV160 (Philippines Owner's Manual Document No. `32K0WA100`)  
**Database Schema Version:** `v5` (migrated non-destructively from `v4`)  
**Date:** 2026-11-09

---

## 1. Features Implemented

### 1.1 Clickable Dashboard Maintenance Items & Maintenance Details Screen
- **Interactive Dashboard Sections (`lib/features/dashboard/presentation/dashboard_screen.dart`):**
  - Every item card under **Overdue maintenance**, **Due maintenance**, **Upcoming maintenance**, **Recently completed maintenance**, and **Last maintenance** is now tappable and routes to `/maintenance/item/:itemId` (`MaintenanceItemDetailScreen`).
  - Summary status pills (**Overdue**, **Due**, **Upcoming**, **Good**, **Completed**, **Condition / unscheduled**) are also interactive and open a filtered bottom sheet allowing the user to tap any item directly to open its details screen.
  - Each Due, Overdue, and Upcoming item card on the Dashboard and Maintenance Screen also provides a one-tap **Log Service** (`+`) quick action that opens the Add Maintenance Log screen pre-populated with that item, its default action, and the current odometer reading.
- **Maintenance Item Details Screen (`lib/features/maintenance/presentation/maintenance_item_detail_screen.dart`):**
  - Displays:
    1. Maintenance item name and category
    2. Current maintenance status badge (`Overdue`, `Due`, `Upcoming`, `Good`, `Completed`, `Condition-based`)
    3. Scheduled odometer interval (side-by-side **Honda Recommendation** and **Your Custom Interval** when a custom interval is configured)
    4. Current odometer reading
    5. Recommended next service odometer (and remaining distance / days)
    6. Last recorded service summary
    7. Prominent **Add Maintenance Log** primary action button (`Key('add_maintenance_log_button')`)
    8. **Component Measurement & Wear Specifications** section and **Measurement History** table
    9. **Service History** list for the selected maintenance item
- **Pre-populated Add Maintenance Log Form (`lib/features/maintenance/presentation/maintenance_form_screen.dart`):**
  - Automatically pre-selects and locks the maintenance item when opened from a specific item (`lockItem: true`) so the user does not have to select it again.
  - Defaults **Service date** to the current date and **Odometer reading** to the current motorcycle odometer.
  - Supports all required **Maintenance actions** (`lib/core/enums/enums.dart`):
    - `Inspected` (`INSPECT`)
    - `Cleaned` (`CLEAN`)
    - `Adjusted` (`ADJUST`)
    - `Replaced` (`REPLACE`)
    - `Repaired` (`REPAIR`)
    - `Lubricated` (`LUBRICATE`)
    - `Other` (`OTHER`)
  - Includes inline **Actual measurement** and **Unit** (`mm`, `km`, etc.) inputs (`Key('maintenance_measurement_field')`, `Key('maintenance_measurement_unit_field')`) that automatically record a linked `ComponentMeasurements` history entry inside the same database transaction.
  - Supports **Parts used**, **Cost** (labor + parts), **Notes**, and **Optional photo attachments** (camera or gallery).
  - **Duplicate Record Prevention (`lib/features/maintenance/data/maintenance_repository.dart`):** Checks for an existing non-voided maintenance record with the same `motorcycleId`, `itemId`, `action`, `performedDate`, and `odometerKm` before inserting, throwing a clear `ValidationException` instead of creating duplicate entries.
  - Automatically refreshes the Maintenance Details screen, Component Measurement status, and Dashboard via Riverpod reactive streams.

---

### 1.2 Component Measurement and Wear Specifications
- **Component Specification Catalog & Evaluator (`lib/features/components/domain/component_models.dart`):**
  - Implemented `ComponentSpecDefinition`, `EvaluatedComponentSpec`, `UserComponentSpec`, and `ComponentSpecStatus` (`Good`, `Monitor`, `Replace`, `Not recorded`).
  - Linked specifications to their corresponding maintenance items so `MaintenanceItemDetailScreen` and `ComponentDetailScreen` display:
    - Component name
    - Standard measurement (if specified)
    - Service limit or replacement limit
    - Source badge (`Honda-specified` vs. `User-defined` vs. `Not available in verified manual`)
    - Current actual measurement and unit (`mm`)
    - Last inspection date and last recorded odometer
    - Computed measurement status (`Good`, `Monitor`, `Replace`, `Not recorded`)
  - **User-Defined Custom Limits:** When a numeric specification is not printed in the verified 2023 Honda ADV160 Owner's Manual (`32K0WA100`), the UI explicitly marks the specification as `"Not available in verified manual"` and provides a **Set Custom Limit** / **Edit Custom Limit** dialog stored in the `component_specs` Drift table.
  - **Measurement History Table:** Displays a chronological table (`Date | Odometer | Component | Measurement`) of all recorded measurements for the component and allows adding new standalone or service-linked measurements.

---

### 1.3 Custom Maintenance Interval Fix & Honda Manual Recommendation Note
- **Custom Maintenance Item & Interval Management:**
  - Users can create new custom maintenance items (e.g., `CVT Cleaning`) via the **Custom Item** FAB on the Maintenance screen (`showCreateCustomItemDialog`) or configure/edit/remove a custom interval on any existing item (`showCustomIntervalDialog`).
  - Supports kilometer intervals (`intervalKm`), month intervals (`intervalMonths`), custom warning thresholds (`warningKm`), and an explicit initial baseline (`lastCompletedKm`).
- **Honda Manual Recommendation Informational Note (`formatHondaRecommendationNote`):**
  - Inside the Custom Interval dialog, an informational card titled **Recommended Interval** displays:
    - The verified Honda ADV160 Owner's Manual schedule (`Inspect (I)`, `Clean (C)`, `Replace (R)` checkpoints and document/page reference) when available; or
    - `"No fixed interval found in the available Honda maintenance schedule. You may set your own custom interval based on your riding conditions."` when no fixed Honda interval exists (e.g., user-defined `CVT Cleaning` or condition-only items).
  - Both **Honda Recommendation** and **Your Custom Interval** are displayed side-by-side on the item status cards and detail screen without overwriting the verified Honda schedule rules.

---

## 2. Root Cause of the Custom Interval Bug

Investigation of the end-to-end custom interval flow (`UI dialog -> MaintenanceViewModel -> MaintenanceRepository -> Drift maintenance_rules table -> MaintenanceCalculator -> MaintenanceOverview -> DashboardScreen`) identified **6 interconnected root causes**:

1. **Incorrect Baseline Fallback in `MaintenanceCalculator._evaluateInterval` (`lib/core/services/maintenance_calculator.dart`):**
   - Previously, `_evaluateInterval` computed the mileage anchor as:
     ```dart
     final fromKm = last?.odometerKm ?? baselineKm ?? 0;
     ```
   - In `MaintenanceRepository.loadSnapshot()`, `baselineKm` is the motorcycle's first confirmed odometer log (`odoLogs.first.odometerKm`). When a user entered their current odometer reading (e.g., `12,800 km`) as their first log and then created a custom interval of `3,000 km`, `fromKm` became `12,800 km` instead of `0 km` (or the last completed service odometer), shifting `Next Due` to `15,800 km` instead of `Last Completed + Interval`.
   - **Fix:** Anchored custom interval calculation to `last?.odometerKm ?? rule.lastCompletedKm ?? 0` (never `baselineKm`), so `Next Due = Last Completed + Custom Interval`.
2. **Strict Action-Code Filtering Ignored Logged Services on Custom Rules:**
   - The old `_showCustomRuleDialog` defaulted `action` to `ActionCode.replace` (`R`), and `_evaluateInterval` filtered service events by `rule.actionCode.isSatisfiedBy(e.action)`. When a user logged `Cleaned` or `Inspected` on a custom rule (such as `CVT Cleaning`), `ActionCode.replace.isSatisfiedBy(MaintenanceAction.clean)` returned `false`, leaving `last == null` so the custom interval never advanced after logging maintenance.
   - **Fix:** For custom rules (`!rule.isManufacturer`), any non-voided service event recorded for that maintenance item satisfies the custom interval and updates the last completed odometer/date.
3. **Uncompleted Early Honda Checkpoints Overshadowed Active Custom Rules in `evaluateItem`:**
   - When a user added a custom interval to an existing Honda item that had an unlogged early checkpoint (e.g., `1,000 km` `OVERDUE`), `evaluateItem` picked the highest severity across all rules (`OVERDUE`), hiding the user's active custom interval status and next due odometer.
   - **Fix:** When an item has an active custom rule, `evaluateItem` uses the custom rule to drive the item's primary `status` and `next` checkpoint while preserving all Honda rules in `ruleEvaluations` so both `Honda Recommendation` and `Your Custom Interval` remain visible.
4. **Duplicate Rule Insertion & Missing Edit/Delete/Create-Item Support in `MaintenanceRepository`:**
   - `addCustomRule` previously performed a blind `INTO maintenance_rules INSERT` without checking if a custom rule already existed for that item, creating duplicate conflicting custom rules on edit, and provided no way to create a custom `MaintenanceItems` entry (such as `CVT Cleaning`) or delete a custom rule.
   - **Fix:** Added `createCustomItemAndRule`, `saveCustomRule` (updates existing custom rule in-place inside a transaction), `deleteCustomRule`, and `deleteCustomItem`.
5. **Missing Custom Rule Columns in `maintenance_rules`:**
   - The table lacked columns for custom warning thresholds and initial baseline odometer/date.
   - **Fix:** Added `warning_km`, `warning_days`, `last_completed_km`, and `last_completed_date` to `maintenance_rules` in schema `v5`.
6. **Dialog Input Parsing & Form Validation:**
   - The old dialog closed before validating inputs and used raw `int.tryParse` without stripping formatting commas or rejecting `<= 0` values inside a `Form`.
   - **Fix:** Replaced with `showCustomIntervalDialog` and `showCreateCustomItemDialog` using `GlobalKey<FormState>`, comma-sanitized positive integer validation, and structured error handling.

---

## 3. Database Changes and Migration (`v4 -> v5`)

- **Schema Version:** Incremented `kDatabaseSchemaVersion` from `4` to `5` in `lib/core/constants/app_constants.dart`.
- **Schema Additions (`lib/core/database/migrations/migrations.dart`):**
  1. `maintenance_items.is_user_defined` (`INTEGER NOT NULL DEFAULT 0`) — distinguishes user-created custom maintenance items from seeded Honda items.
  2. `maintenance_rules.warning_km` (`INTEGER NULL`) — optional custom upcoming warning threshold in km.
  3. `maintenance_rules.warning_days` (`INTEGER NULL`) — optional custom upcoming warning threshold in days.
  4. `maintenance_rules.last_completed_km` (`INTEGER NULL`) — optional baseline odometer when no service record exists yet.
  5. `maintenance_rules.last_completed_date` (`INTEGER NULL`) — optional baseline date when no service record exists yet.
  6. New table `component_specs` (`id`, `spec_key UNIQUE`, `standard_value`, `service_limit`, `unit`, `notes`, `updated_at`) — stores user-defined component wear limits for specifications not printed in the verified Honda Owner's Manual.
- **Data Integrity & Backward Compatibility:**
  - All `v4 -> v5` migration steps use idempotent column-existence checks (`_addColumnIfMissing`) and `CREATE TABLE IF NOT EXISTS`, preserving 100% of existing motorcycles, odometer logs, maintenance records, custom rules, and component measurements.
  - `BackupService` (`lib/core/services/backup_service.dart`) exports and restores `component_specs` while remaining backward-compatible with `v1–v4` backup archives.

---

## 4. Component Measurement Specifications and Official Sources

All specifications were audited strictly against the **2023 Honda ADV160 Philippines Owner's Manual (`32K0WA100`)**:

| Component | Spec Key | Standard Measurement | Service / Replacement Limit | Unit | Official Source (`32K0WA100`) | Status in App |
|---|---|---|---|---|---|---|
| **Front Tire Tread Depth** | `front_tire_tread` | — | `1.5` (min) | `mm` | Owner's Manual pp. 96, 142 (`0.06 in / 1.5 mm`) | **Verified Honda-specified** (`Replace` at `<= 1.5 mm`, `Monitor` at `<= 2.0 mm`, `Good` at `> 2.0 mm`) |
| **Rear Tire Tread Depth** | `rear_tire_tread` | — | `2.0` (min) | `mm` | Owner's Manual pp. 96, 142 (`0.08 in / 2.0 mm`) | **Verified Honda-specified** (`Replace` at `<= 2.0 mm`, `Monitor` at `<= 2.5 mm`, `Good` at `> 2.5 mm`) |
| **Throttle Grip Freeplay** | `throttle_freeplay` | `2.0 – 6.0` (flange) | `2.0` min / `6.0` max | `mm` | Owner's Manual p. 110 (`1/16 – 1/4 in / 2 – 6 mm`) | **Verified Honda-specified** (`Good` within `2.0–6.0 mm`, `Monitor` within `0.5 mm` of bounds, `Replace/Adjust` outside `2.0–6.0 mm`) |

---

## 5. Specifications That Could Not Be Verified in the Owner's Manual

The following components do **not** have numeric millimeter (`mm`) wear limits printed in the **2023 Honda ADV160 Owner's Manual (`32K0WA100`)** (numeric workshop limits reside only in the separate Honda ADV160 Shop/Service Manual or stamped on the rotor). Per project rules, **no values were invented or guessed**:

| Component | Spec Key | Owner's Manual (`32K0WA100`) Guidance | App Handling |
|---|---|---|---|
| **Drive Belt (Width)** | `drive_belt` | p. 89: Inspect at `12,000 km` & `36,000 km`; Replace every `24,000 km`. Numeric belt width (`mm`) is not printed in `32K0WA100`. | Marked `"Not available in verified manual"`. Supports user-defined custom standard & service limit (`mm`) + full measurement history. |
| **Front Brake Pad Lining** | `front_brake_pad` | p. 108: Inspect pad wear indicator grooves every `6,000 km`; replace if worn to the indicator groove. Numeric lining thickness (`mm`) is not printed in `32K0WA100`. | Marked `"Not available in verified manual"`. Supports user-defined custom limit (`mm`) + visual wear indicator note + full measurement history. |
| **Rear Brake Pad Lining** | `rear_brake_pad` | p. 108: Inspect pad wear indicator grooves every `6,000 km`; replace if worn to the indicator groove. Numeric lining thickness (`mm`) is not printed in `32K0WA100`. | Marked `"Not available in verified manual"`. Supports user-defined custom limit (`mm`) + visual wear indicator note + full measurement history. |
| **Front Brake Disc Thickness** | `front_brake_disc` | Numeric disc thickness (`mm`) is not printed in `32K0WA100` (minimum thickness is stamped as `MIN. TH.` on the rotor / Service Manual). | Marked `"Not available in verified manual"`. Supports user-defined custom limit (`mm`) + full measurement history. |
| **Rear Brake Disc Thickness** | `rear_brake_disc` | Numeric disc thickness (`mm`) is not printed in `32K0WA100` (minimum thickness is stamped as `MIN. TH.` on the rotor / Service Manual). | Marked `"Not available in verified manual"`. Supports user-defined custom limit (`mm`) + full measurement history. |

---

## 6. Tests Performed and Results

### Static Analysis
- Command: `flutter analyze`
- Result: **Passed (`No issues found!`)**

### Automated Test Suite (`flutter test`)
All **15 automated test groups/cases** across 3 test suites passed (`00:05 +15: All tests passed!`):

1. **`test/unit/custom_interval_and_specs_test.dart` (9 unit tests — Passed):**
   - Custom interval calculation from `0 km`, `lastCompletedKm`, and recorded maintenance logs (verifying `CVT Cleaning` every `3,000 km` with last completed at `12,000 km` and current odometer `12,800 km` -> `Next Due = 15,000 km`, `Remaining = 2,200 km`, `Status = Good`).
   - Status transitions across `Good` (`12,800 km`), `Upcoming` (`14,600 km`), `Due` (`15,000 km`), and `Overdue` (`15,200 km`).
   - Verification that logging any maintenance action (`Cleaned`, `Inspected`, `Replaced`, `Repaired`, `Other`) advances a custom interval's `Next Due` checkpoint.
   - Verification that a custom interval on a Honda-scheduled item drives the item's primary status while preserving the Honda rule evaluation for side-by-side display.
   - Component measurement status evaluation (`Not recorded`, `Good`, `Monitor`, `Replace`) for both verified Honda specs (`Front Tire Tread Depth`, `Rear Tire Tread Depth`, `Throttle Grip Freeplay`) and user-defined specs (`Drive Belt`, `Brake Pads`, `Brake Discs`).
   - Honda Manual Recommendation note formatting when a verified Honda schedule exists vs. when no fixed Honda interval exists.

2. **`test/database/enhancement_database_test.dart` (5 database & migration tests — Passed):**
   - Full custom interval lifecycle in Drift (`createCustomItemAndRule`, calculation via `MaintenanceOverview`, `saveCustomRule` in-place update without duplicate rules, `deleteCustomRule`, and rejection of invalid `<= 0` intervals).
   - File-backed SQLite persistence test verifying custom items and custom intervals survive closing and reopening the database file.
   - Component measurement history persistence (`multiple measurements over time`) and `component_specs` user-defined limit persistence.
   - Inline component measurement creation when saving a maintenance record + duplicate maintenance record prevention (`ValidationException`).
   - Real SQLite schema migration test from `v4` to `v5` verifying existing maintenance records, custom rules, and odometer readings are preserved without data loss.

3. **`test/widget/dashboard_and_detail_widget_test.dart` (1 end-to-end widget flow test — Passed):**
   - Renders `AdvMonApp` on the Dashboard with Overdue (`Engine Oil`) and Due (`Throttle Operation`) items.
   - Taps the Overdue item and verifies navigation to `MaintenanceItemDetailScreen` with current status, scheduled interval, current odometer (`6,000 km`), recommended next service odometer, Component Measurement & Wear Specifications card, and `Add Maintenance Log` button.
   - Taps the Due item (`Throttle Operation`), verifies `Throttle Grip Freeplay` (`2.0 – 6.0 mm (Honda-specified)`), taps `Add Maintenance Log`, verifies `MaintenanceFormScreen` is pre-populated with `Throttle Operation`, enters an inline measurement (`3.5 mm`), saves the record, and verifies both `MaintenanceItemDetailScreen` (`3.50 mm` -> `Good`, next due `12,000 km`) and `DashboardScreen` update immediately.

---

## 7. Known Issues / Limitations

- **Physical Android Device Verification:** Automated unit, database migration, widget tests, and the production release APK build were executed and verified in this environment; manual touch verification on a physical Android handset must be performed by installing the generated APK below.
- **Workshop Service Manual Numeric Wear Limits:** Because only the official 2023 Honda ADV160 Owner's Manual (`32K0WA100`) is bundled/verified in the repository, workshop-only millimeter wear limits for Drive Belt width, Brake Pad lining thickness, and Brake Disc thickness are marked `"Not available in verified manual"` and can be entered by the user via **Set Custom Limit** if they have a workshop manual or rotor stamping reference.

---

## 8. APK Build Result and Location

- **Command:** `flutter build apk --release`
- **Build Status:** **Succeeded**
- **Release APK Path:** `c:\xampp2\htdocs\adv-mon\build\app\outputs\flutter-apk\app-release.apk`

