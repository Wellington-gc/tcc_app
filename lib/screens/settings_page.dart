import 'package:flutter/material.dart';
import 'package:tcc_app/screens/bluetooth_settings_page.dart';
import 'package:tcc_app/screens/email_settings_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.bluetooth),
              title: const Text(
                'Bluetooth',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return BluetoothSettingsScreen();
                    },
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: const Text(
                'Email',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return const EmailSettingsScreen();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
