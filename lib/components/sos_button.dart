import 'package:flutter/material.dart';

class SosButton extends StatelessWidget {
  const SosButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text(
        'SOS',
        style: TextStyle(fontSize: 100),
      ),
      // Icon(
      //   Icons.notifications_active,
      //   size: 150,
      //   color: Colors.white,
      // ),
      onPressed: () {},
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
