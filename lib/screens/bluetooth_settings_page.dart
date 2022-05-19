import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hive/hive.dart';
import 'package:tcc_app/models/fall_code.dart';

class BluetoothSettingsScreen extends StatefulWidget {
  BluetoothSettingsScreen({Key? key}) : super(key: key);

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final List<int> fallCode = <int>[];

  @override
  State<BluetoothSettingsScreen> createState() =>
      _BluetoothSettingsScreenState();
}

class _BluetoothSettingsScreenState extends State<BluetoothSettingsScreen> {
  Box<FallCode> fallCodesBox = Hive.box<FallCode>('fall_codes');
  List<BluetoothService> _services = <BluetoothService>[];
  BluetoothService? _fallService;
  BluetoothCharacteristic? _fallCharacteristic;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: widget.devicesList.map(
          (device) {
            return Card(
              child: ListTile(
                title: Text(
                  device.name == ''
                      ? '(Dispositivo desconhecido)'
                      : device.name,
                ),
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
                            (value) {
                              // showNotification();
                            },
                          );
                        },
                      );

                      await _fallCharacteristic?.setNotifyValue(true);
                    }
                  },
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
