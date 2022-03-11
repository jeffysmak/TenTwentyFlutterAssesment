import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ten_twenty/main.dart';

class NetworkConnectivityHelper {
  Future<bool> checkConnectivity() async {
    return (await _initConnectivity()) && kIsWeb ? true : (await _checkInternetAccess(navigatorKey.currentContext!));
  }

  Future<bool> _initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result != ConnectivityResult.none;
  }

  Future<bool> _checkInternetAccess(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
