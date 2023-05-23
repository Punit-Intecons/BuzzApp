import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static StreamBuilder<ConnectivityResult> buildConnectivityStreamBuilder(
      Widget Function(bool hasConnectivity) builder) {
    final Connectivity _connectivity = Connectivity();

    return StreamBuilder<ConnectivityResult>(
      stream: _connectivity.onConnectivityChanged,
      builder: (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        final hasConnectivity = snapshot.data != ConnectivityResult.none;
        return builder(hasConnectivity);
      },
      // Assume no connectivity initially
    );
  }
}
