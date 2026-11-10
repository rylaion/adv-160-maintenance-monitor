# ADV MON – Honda ADV 160 Maintenance & Ride Monitor

**A motorcycle maintenance, ride tracking, and parts management application for the Honda ADV 160.**

ADV MON is a Flutter-based Android application designed specifically for Honda ADV 160 owners. It provides a centralized platform for managing motorcycle maintenance, tracking ride activities, monitoring component conditions, configuring CVT setups, and browsing motorcycle parts.

The application helps owners maintain their motorcycles through organized service records, mileage-based maintenance schedules, component specifications, ride history, and maintenance reminders.

ADV MON is designed with offline-first functionality, storing motorcycle records locally on the device.

---

## Features

### 1. Maintenance Dashboard

A centralized dashboard for monitoring the overall condition and maintenance status of your motorcycle.

- View current motorcycle odometer readings.
- Monitor upcoming and overdue maintenance.
- View maintenance activities that are due.
- Access the last recorded maintenance.
- Monitor maintenance progress based on mileage.
- View maintenance summaries and statistics.
- Quickly access maintenance logs from due maintenance items.
- Update motorcycle mileage.

### 2. Maintenance Tracking

Monitor and manage maintenance schedules for important Honda ADV 160 components.

| Component | Maintenance Monitoring |
|---|---|
| Engine Oil | Oil replacement schedule |
| CVT Belt | Inspection and replacement |
| Fuel System | Fuel system maintenance |
| Brake System | Brake pad inspection and thickness monitoring |
| Battery | Battery condition and voltage monitoring |
| Tires | Tire inspection, tread depth, and pressure |
| Coolant | Coolant inspection and replacement |
| Gear Oil | Gear oil replacement |
| CVT Components | CVT inspection and maintenance |

Additional capabilities:

- Record maintenance activities.
- Track maintenance using odometer readings.
- Monitor component conditions.
- View recommended maintenance specifications.
- Record actual component measurements.
- Monitor component replacement intervals.
- Maintain individual maintenance histories.

### 3. Component Condition Monitoring

Monitor the physical condition and measurements of important motorcycle components.

Examples include:

| Component | Measurement |
|---|---|
| CVT Belt | Belt width / thickness (mm) |
| Brake Pads | Brake pad thickness (mm) |
| Tires | Tread depth and tire pressure |
| Battery | Battery voltage |
| Coolant | Coolant condition |
| Other Components | Custom inspection measurements |

The application provides recommended measurement references where specifications are available in the Honda ADV 160 owner's manual.

Users can compare recorded measurements against recommended service limits to help determine when inspection or replacement is necessary.

### 4. Maintenance History & Service Logs

Maintain a complete record of motorcycle maintenance activities.

- Record completed maintenance.
- Save service dates and odometer readings.
- Add maintenance descriptions and notes.
- Record component conditions.
- Track replaced parts.
- Review previous maintenance activities.
- Access maintenance history from individual dashboard items.

### 5. Custom Maintenance Intervals

Create personalized maintenance schedules for components and activities that are not covered by the default maintenance schedule.

- Add custom maintenance activities.
- Configure mileage-based intervals.
- Set custom maintenance descriptions.
- Monitor upcoming and overdue custom activities.
- View recommended mileage ranges where applicable.
- Display maintenance guidance to help users select appropriate intervals.

Custom intervals allow owners to monitor additional maintenance activities without modifying the standard Honda maintenance recommendations.

### 6. Maintenance Reminders

Stay informed about upcoming motorcycle maintenance.

- Monitor upcoming maintenance schedules.
- Identify overdue maintenance.
- Receive local notifications for scheduled maintenance.
- Track maintenance based on current odometer readings.

### 7. Ride History & Trip Logger

Record and review motorcycle trips using GPS tracking.

- Record motorcycle trips.
- Track GPS locations.
- Monitor trip distance.
- Record ride duration.
- Review previous trips.
- View recorded routes on the map.
- Maintain a history of motorcycle rides.

### 8. GPS Map & Navigation

An integrated map feature for viewing locations and managing motorcycle routes.

- Display maps using OpenStreetMap.
- Access current GPS location.
- View motorcycle position on the map.
- Track GPS routes.
- Plan and view travel routes.
- Access map controls for zooming and centering.
- Review recorded ride routes.

**Map Technology:** OpenStreetMap and Flutter Map.

Note: Map tiles and online route services may require an internet connection. GPS-based location tracking is separate from map tile availability.

### 9. CVT Configuration Manager

Manage and document different CVT tuning configurations for the Honda ADV 160.

- Create custom CVT configurations.
- Record flyball / roller weights.
- Record clutch spring specifications.
- Record center spring specifications.
- Record pulley configurations.
- Save tuning notes.
- Compare different CVT setups.
- Maintain a history of previous configurations.

This feature helps owners document their CVT experiments and identify configurations that work best for their riding preferences.

### 10. Honda ADV 160 Parts Catalogue

Browse and manage motorcycle components through an organized parts catalogue.

- Browse available motorcycle parts.
- Organize components by category.
- Search for specific parts.
- View parts diagrams where available.
- Open individual diagram viewers.
- View part information and descriptions.
- Access replacement information.
- Record component replacements.
- Maintain replacement history.

The catalogue provides a convenient reference when inspecting, maintaining, or replacing motorcycle components.

### 11. Parts Replacement Tracking

Keep track of installed and replaced motorcycle components.

- Record replacement activities.
- Save replacement dates.
- Record odometer readings during replacement.
- Maintain replacement history.
- Monitor component replacement schedules.
- Connect replacement records with maintenance tracking.

This helps prevent missed replacements and provides a reference for future maintenance.

### 12. Offline Support

ADV MON follows an offline-first approach for motorcycle maintenance and record management.

- Store maintenance records locally.
- Access maintenance history without internet.
- Manage custom maintenance intervals offline.
- View saved CVT configurations.
- Access locally stored motorcycle information.
- Keep important motorcycle records accessible anytime.

Some features, particularly online maps and external map services, may require internet connectivity.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile application framework |
| Dart | Programming language |
| Material 3 | User interface design |
| Riverpod | State management |
| Drift / SQLite | Local database |
| GoRouter | Application navigation |
| FL Chart | Data visualization |
| Local Notifications | Maintenance reminders |
| Flutter Map | Map display |
| OpenStreetMap | Map data |
| Geolocator | GPS and location services |

---

## Target Motorcycle

| Information | Details |
|---|---|
| Brand | Honda |
| Model | ADV 160 |
| Model Year | 2023 |
| Platform | Android |
| Application Name | ADV MON |
| Application Type | Motorcycle Maintenance & Ride Monitor |

---

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

---

## Development Commands

| Command | Description |
|---|---|
| `flutter pub get` | Install project dependencies |
| `flutter analyze` | Check for code issues |
| `flutter test` | Run automated tests |
| `flutter run` | Run the application |
| `flutter build apk --debug` | Build a debug APK |
| `flutter build apk --release` | Build a release APK |

---

## Project Structure

The application is organized into separate modules to make development and maintenance easier.

| Module | Responsibility |
|---|---|
| Dashboard | Motorcycle overview and maintenance status |
| Maintenance | Maintenance schedules and service records |
| Components | Component specifications and condition monitoring |
| Ride History | GPS tracking and recorded trips |
| Maps | Map display and route management |
| CVT Manager | CVT configurations and tuning records |
| Parts Catalogue | Motorcycle parts and diagrams |
| Replacement Tracking | Component replacement records |
| Database | Local data storage |
| Notifications | Maintenance reminders |

---

## Maintenance Reference

Maintenance recommendations
