
# BLE Foreground Scanner (Flutter + Android)

This project demonstrates **continuous BLE scanning** in a Flutter application using an **Android foreground service**.

The key goal of this project is to ensure that **BLE scanning continues reliably** even when:

* The app is in the background
* The phone screen is locked
* The app is removed from recent apps (killed state)

This is achieved using native Android code integrated with Flutter via platform channels.

---

## Features

* Continuous BLE scanning on Android
* Foreground service with persistent notification
* Works on lock screen
* Continues scanning after app is removed from recents
* Sends scanned BLE devices back to Flutter UI
* Optimized scan settings to reduce battery drain
* Packaged as a reusable Flutter plugin

---

## How It Works

* Flutter UI communicates with native Android using **MethodChannel** and **EventChannel**
* BLE scanning is handled entirely in native Android
* A **foreground service** keeps the BLE scanner alive
* The service survives background, lock screen, and app termination
* Scan results are streamed back to Flutter when available

> ⚠️ Note: Due to Android system limitations, BLE scan callbacks cannot be delivered to Flutter while the Flutter engine is detached. Once the app is opened again, scanning continues without interruption.

---

## Project Structure

```
ble_foreground_scanner/
│
├── lib/
│   └── ble_foreground_scanner.dart     # Flutter plugin API
│
├── android/
│   └── src/main/kotlin/com/example/ble_foreground_scanner/
│       ├── BleForegroundScannerPlugin.kt
│       ├── BleScanService.kt
│       └── BleScanReceiver.kt
│
├── example/
│   └── lib/main.dart                   # Demo Flutter app
│
└── pubspec.yaml
```

---

## Android Permissions Used

The following permissions are required and already configured:

```xml
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
```

> On Android 12+, runtime permission for `BLUETOOTH_SCAN` is required.

---

## Running the Project

### Prerequisites

* Flutter SDK (stable)
* Android Studio
* Android device (real device recommended for BLE)
* Android 8.0+ (API 26+)

### Steps

```bash
flutter pub get
cd example
flutter pub get
flutter run
```

---

## Usage (Flutter Side)

```dart
await BleForegroundScanner.startScan();

BleForegroundScanner.scanResults.listen((device) {
  print(device);
});
```

To stop scanning:

```dart
await BleForegroundScanner.stopScan();
```

---

## Foreground Service Behavior

* A persistent notification is shown while scanning
* The service continues running:

  * when the screen is locked
  * when the app is backgrounded
  * after the app is removed from recent apps
* Android system controls battery usage automatically

---

## Battery Optimization Notes

* Uses balanced BLE scan mode
* Avoids aggressive scan intervals
* Foreground service prevents OS from killing the scanner
* Suitable for long-running BLE monitoring use cases

---

## Tested On

* Android 13 / 14
* Samsung devices
* Pixel emulator (limited BLE)
* Real BLE peripherals

---

## Limitations

* Android only (iOS background BLE requires different approach)
* Flutter UI cannot receive events while engine is fully killed
* Some OEMs may apply aggressive battery optimizations

---

## Use Cases

* BLE beacons
* Asset tracking
* Proximity detection
* Background device monitoring
* IoT scanning applications

---

## License

MIT License

---
