import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:tcc_app/models/fall_code.dart';
import 'package:tcc_app/screens/alarm_page.dart';
import 'package:timezone/timezone.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final List<int> fallCode = <int>[];

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Box<FallCode> fallCodesBox = Hive.box<FallCode>('fall_codes');
  List<BluetoothService> _services = <BluetoothService>[];
  BluetoothService? _fallService;
  BluetoothCharacteristic? _fallCharacteristic;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  Future onSelectNotification(String? payload) async {
    //Handle notification tapped logic here
    print(payload);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const AlarmScreen();
        },
      ),
    );
  }

  showNotification() async {
    await flutterLocalNotificationsPlugin!.zonedSchedule(
      Random().nextInt(999),
      'Queda detectada!',
      '',
      TZDateTime.now(getLocation('America/Sao_Paulo'))
          .add(const Duration(seconds: 1)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '1', 'channelName',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          enableVibration: true,
          // vibrationPattern: vibrationPattern,
          setAsGroupSummary: false,
          groupAlertBehavior: GroupAlertBehavior.all,
          autoCancel: true,
          ongoing: false,
          // onlyAlertOnce: true,
          showWhen: true,
          channelShowBadge: true,
          showProgress: false,
          maxProgress: 0,
          progress: 0,
          indeterminate: true,
          channelAction: AndroidNotificationChannelAction.createIfNotExists,
          enableLights: true,
          fullScreenIntent: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );

    // await flutterLocalNotificationsPlugin!.show(
    //   Random().nextInt(999),
    //   'Queda detectada!',
    //   '',
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'your channel id',
    //       'your channel name',
    //       channelDescription: 'your channel description',
    //       importance: Importance.max,
    //       priority: Priority.max,
    //       fullScreenIntent: true,
    //       showWhen: true,
    //       timeoutAfter: 10,
    //       visibility: NotificationVisibility.public,
    //     ),
    //   ),
    //   payload: '',
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: widget.devicesList.map((device) {
          return Card(
            child: ListTile(
              title: Text(device.name == ''
                  ? '(Dispositivo desconhecido)'
                  : device.name),
              subtitle: Text(device.id.toString()),
              trailing: ElevatedButton(
                child: const Text('Conectar'),
                onPressed: () async {
                  widget.flutterBlue.stopScan();
                  try {
                    await device.connect();
                  } catch (e) {
                    rethrow;
                  } finally {
                    _services = await device.discoverServices();

                    _fallService = _services.singleWhere((element) =>
                        element.uuid ==
                        Guid('7895d8d8-3220-11ec-8d3d-0242ac130003'));

                    _fallCharacteristic = _fallService?.characteristics
                        .singleWhere(
                            (element) => element.properties.notify == true);

                    _fallCharacteristic?.value.listen(
                      (value) {
                        fallCodesBox
                            .add(
                              FallCode(
                                code: value.last,
                              ),
                            )
                            .then(
                              (value) => showNotification(),
                            );
                        print(fallCodesBox.values.last.code);
                      },
                    );

                    await _fallCharacteristic?.setNotifyValue(true);
                  }
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
