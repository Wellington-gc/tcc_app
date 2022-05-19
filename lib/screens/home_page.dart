import 'package:flutter/material.dart';
import 'package:tcc_app/components/contacts_button.dart';
import 'package:tcc_app/components/settings_button.dart';
import 'package:tcc_app/components/sos_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detecção de queda'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SosButton(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ContactsButton(),
                  SettingsButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
