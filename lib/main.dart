import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ble_foreground_scanner/ble_foreground_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _start() async {
    final permissions = [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.notification, // 🔥 REQUIRED
    ];

    final result = await permissions.request();

    if (result.values.every((e) => e.isGranted)) {
      await BleForegroundScanner.startScan();
    } else {
      debugPrint('Required permissions not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('BLE Foreground Scan')),
        body: StreamBuilder(
          stream: BleForegroundScanner.scanStream(),
          builder: (context, snapshot) {
            final devices = snapshot.data ?? [];
            return ListView(
              children: devices.map<Widget>((d) {
                return ListTile(
                  title: Text(d.name),
                  subtitle: Text(d.id),
                  trailing: Text('${d.rssi}'),
                );
              }).toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _start,
          child: const Icon(Icons.bluetooth),
        ),
      ),
    );
  }
}
