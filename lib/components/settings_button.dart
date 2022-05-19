import 'package:flutter/material.dart';
import 'package:tcc_app/screens/settings_page.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        child: const Icon(
          Icons.settings,
          size: 60,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return const SettingsScreen();
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(125, 75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,
        ),
      ),
    );
  }
}
