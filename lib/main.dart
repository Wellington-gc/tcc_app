import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tcc_app/models/contact.dart';
import 'package:tcc_app/models/fall_code.dart';
import 'package:tcc_app/models/setting.dart';
import 'package:tcc_app/screens/home_page.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await Hive.initFlutter();
  Hive.registerAdapter<Contact>(ContactAdapter());
  Hive.registerAdapter<FallCode>(FallCodeAdapter());
  Hive.registerAdapter<Setting>(SettingAdapter());
  await Hive.openBox<Contact>('contacts');
  await Hive.openBox<FallCode>('fall_codes');
  await Hive.openBox<Setting>('settings');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fall Alert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      home: HomePage(key: key),
    );
  }
}
