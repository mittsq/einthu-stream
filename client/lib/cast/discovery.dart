// import 'package:flutter/material.dart';
import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';
import 'package:observable/observable.dart';

class ServiceDiscovery extends ChangeNotifier {
  FlutterMdnsPlugin _flutterMdnsPlugin;
  Set<ServiceInfo> foundServices = Set();

  ServiceDiscovery() {
    _flutterMdnsPlugin = FlutterMdnsPlugin(
      discoveryCallbacks: DiscoveryCallbacks(
          onDiscoveryStarted: () => {},
          onDiscoveryStopped: () => {},
          onDiscovered: (serviceInfo) => {},
          onResolved: (serviceInfo) {
            if (foundServices
                .map((s) => s.address)
                .contains(serviceInfo.address)) return;
            foundServices.add(serviceInfo);
            notifyChange();
          }),
    );
  }

  startDiscovery() {
    _flutterMdnsPlugin.startDiscovery('_googlecast._tcp');
  }
}
