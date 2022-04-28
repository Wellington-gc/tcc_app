import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final List<int> fallCode = <int>[];

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<BluetoothService> _services = <BluetoothService>[];
  BluetoothService? _fallService;
  BluetoothCharacteristic? _fallCharacteristic;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSetttings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: selectNotification);
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

  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  showNotification() async {
    await flutterLocalNotificationsPlugin.show(
      1,
      'Queda detectada!',
      '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true,
          showWhen: true,
        ),
      ),
      payload: '',
    );
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

                    _fallCharacteristic?.value.listen((value) {
                      setState(() {
                        widget.fallCode.add(value.last);
                      });
                      print(widget.fallCode.toString());
                    });

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
