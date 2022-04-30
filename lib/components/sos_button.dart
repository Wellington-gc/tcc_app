import 'package:flutter/material.dart';
import 'package:tcc_app/screens/alarm_page.dart';

class SosButton extends StatelessWidget {
  const SosButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text(
        'SOS',
        style: TextStyle(fontSize: 100),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return const AlarmScreen();
            },
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(300, 300),
        shape: const CircleBorder(),
        primary: Colors.red,
        elevation: 10,
        side: const BorderSide(
          style: BorderStyle.solid,
          width: 5,
        ),
      ),
    );
  }
}
