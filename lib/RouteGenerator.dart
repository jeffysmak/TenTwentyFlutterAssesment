import 'package:flutter/cupertino.dart';
import 'package:ten_twenty/ui/BookSeatScreen.dart';
import 'package:ten_twenty/ui/MovieDetailed.dart';
import 'package:ten_twenty/ui/PlayerScreen.dart';
import 'package:ten_twenty/ui/SeatsAvailableScreen.dart';
import 'package:ten_twenty/ui/dashboard.dart';
import 'package:ten_twenty/ui/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case SplashScreen.Route:
        return CupertinoPageRoute(builder: (_) => SplashScreen());
      case DashboardScreen.Route:
        return CupertinoPageRoute(builder: (_) => DashboardScreen());
      case MovieDetailedScreen.Route:
        return CupertinoPageRoute(builder: (_) => MovieDetailedScreen());
      case SeatsAvailableScreen.Route:
        return CupertinoPageRoute(builder: (_) => SeatsAvailableScreen());
      case BookSeatsAvailableScreen.Route:
        return CupertinoPageRoute(builder: (_) => BookSeatsAvailableScreen());
      case PlayerScreen.Route:
        return CupertinoPageRoute(builder: (_) => PlayerScreen());
      default:
        return CupertinoPageRoute(builder: (_) => ErrorRoute());
    }
  }
}

class ErrorRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Some kind of route error view'),
      ),
    );
  }
}
