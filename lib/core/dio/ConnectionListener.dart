import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  StreamSubscription? _subscription;

  Future<void> initialize() async {
    final hasInternet = await InternetConnection().hasInternetAccess;
    _isOnline = hasInternet;
    notifyListeners();

    _subscription = _connectivity.onConnectivityChanged.listen((_) async {
      final isConnected = await InternetConnection().hasInternetAccess;
      if (_isOnline != isConnected) {
        _isOnline = isConnected;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
