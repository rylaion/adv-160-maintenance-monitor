# ADV MON – ADV 160 Maintenance Monitor

**A personal motorcycle maintenance monitoring application for the Honda ADV 160.**

ADV MON is a Flutter-based mobile application designed to help Honda ADV 160 owners monitor motorcycle maintenance schedules, record service history, track component conditions, and receive maintenance reminders.

The application focuses on making motorcycle maintenance easier to manage by keeping important service records and maintenance information organized in one place.

## Features

### 1. Maintenance Dashboard
- View motorcycle maintenance status.
- Monitor upcoming and overdue maintenance.
- Track maintenance progress based on motorcycle mileage.
- Quickly access maintenance records.

### 2. Maintenance Tracking
Monitor important motorcycle components, including:

| Component | Maintenance Monitoring |
|---|---|
| Engine Oil | Oil replacement schedule |
| CVT Belt | Inspection and replacement |
| Fuel System | Fuel-related maintenance |
| Brake System | Brake inspection and maintenance |
| Battery | Battery condition monitoring |
| Tires | Tire inspection and replacement |
| Coolant | Coolant inspection and replacement |
| Gear Oil | Gear oil replacement |

### 3. Maintenance History
- Record completed maintenance activities.
- Save service dates and odometer readings.
- Add maintenance notes.
- Review previous maintenance records.

### 4. Maintenance Reminders
- Monitor upcoming maintenance schedules.
- Identify overdue maintenance.
- Receive local notifications for scheduled maintenance.

### 5. Custom Maintenance Intervals
- Create custom maintenance schedules.
- Configure maintenance intervals based on mileage.
- Track custom maintenance activities.

### 6. Offline Support
- Access maintenance information without an internet connection.
- Store records locally on the device.
- Keep motorcycle maintenance information accessible anytime.

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile application framework |
| Dart | Programming language |
| Material 3 | User interface |
| Riverpod | State management |
| Drift / SQLite | Local database |
| GoRouter | Application navigation |
| FL Chart | Data visualization |
| Local Notifications | Maintenance reminders |

## Target Motorcycle

- **Brand:** Honda
- **Model:** ADV 160
- **Model Year:** 2023
- **Application Platform:** Android

## Getting Started

### Prerequisites

Install the following development tools:

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android SDK
- Git

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/rylaion/adv-160-maintenance-monitor.git
   ```

2. Navigate to the project directory:

   ```bash
   cd adv-160-maintenance-monitor
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Check the project:

   ```bash
   flutter analyze
   ```

5. Run the application:

   ```bash
   flutter run
   ```

### Build APK

To generate a release APK:

```bash
flutter build apk --release
```

The generated APK can be found at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Development Commands

| Command | Description |
|---|---|
| `flutter pub get` | Install project dependencies |
| `flutter analyze` | Check for code issues |
| `flutter test` | Run automated tests |
| `flutter run` | Run the application |
| `flutter build apk --debug` | Build a debug APK |
| `flutter build apk --release` | Build a release APK |

## Project Repository

GitHub: https://github.com/rylaion/adv-160-maintenance-monitor

## Maintenance Reference

Maintenance recommendations should follow the official Honda ADV 160 owner's manual.

**Reference:**
- Motorcycle: Honda ADV 160 (2023)
- Owner's Manual: Honda ADV160
- Manual reference: 32K0WA100
