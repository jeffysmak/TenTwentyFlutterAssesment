import 'package:flutter/material.dart';
import 'package:ten_twenty/ui/dashboard.dart';

class SplashScreen extends StatefulWidget {
  static const Route = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () => Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.Route, (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('A Splash\nScreen 😁', textAlign: TextAlign.center)));
  }
}
