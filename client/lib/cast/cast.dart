import 'package:dart_chromecast/casting/cast.dart';
import 'package:einthu_stream/cast/discovery.dart';
import 'package:flutter/material.dart';

class CastEngine {
  CastEngine._();

  static CastSender _connection;
  static List<CastDevice> _devices;
  static ServiceDiscovery _discovery;
  static DevicePicker _dp;

  static bool _isConnected = false;

  static bool get isConnected => _isConnected;

  static void initialize() {
    return;

    if (_discovery == null) _discovery = ServiceDiscovery();
    if (_dp == null)
      _dp = DevicePicker(
        serviceDiscovery: _discovery,
      );
    _isConnected = false;
    _discovery.startDiscovery();
  }

  // static void startDiscovery() {
  //   _discovery.startDiscovery();
  // }

  static Future pickDevice(BuildContext context) async {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Native casting is coming soon! Use a third-party caster in the meantime.'),
      ),
    );
    return;

    if (_isConnected) {
      _isConnected = false;
      _connection.stop();
      await _connection.disconnect();
      return;
    }

    // _discovery.startDiscovery();

    final host = await showDialog<CastDevice>(
      context: context,
      builder: (context) => _dp,
    );
    if (host == null) return;

    _connection = CastSender(host);
    final success = await _connection.connect();
    if (!success) {
      // error
      _connection.stop();
      await _connection.disconnect();
      _isConnected = false;
      print('Connection error');
      return;
    }
    _connection.launch();
    _isConnected = true;
  }
}

class DevicePicker extends StatefulWidget {
  final ServiceDiscovery serviceDiscovery;

  DevicePicker({this.serviceDiscovery});

  @override
  _DevicePickerState createState() => _DevicePickerState();
}

class _DevicePickerState extends State<DevicePicker> {
  Set<CastDevice> _devices = Set();

  void initState() {
    super.initState();
    widget.serviceDiscovery.changes.listen((_) {
      _updateDevices();
    });
    _updateDevices();
  }

  _updateDevices() {
    // _devices.clear();
    widget.serviceDiscovery.foundServices.forEach((serviceInfo) {
      if (serviceInfo.port == 0 || !serviceInfo.name.startsWith('Chromecast'))
        return;
      if (_devices.map((d) => d.host).contains(serviceInfo.address)) return;
      setState(() {
        final cd = CastDevice(
          name: serviceInfo.name,
          type: serviceInfo.type,
          host: serviceInfo.hostName,
          port: serviceInfo.port,
        );
        _devices.add(cd);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Cast to ...'),
      children: _devices.map((d) {
        return SimpleDialogOption(
          child: Text(d.friendlyName),
          onPressed: () {
            Navigator.pop(context, d);
          },
        );
      }).toList(),
    );
  }
}
