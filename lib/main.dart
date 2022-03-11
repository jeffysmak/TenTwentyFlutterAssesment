import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty/RouteGenerator.dart';
import 'package:ten_twenty/notifiers/HomeScreenController.dart';
import 'package:ten_twenty/notifiers/MovieListController.dart';
import 'package:ten_twenty/theme/ThemeNotifier.dart';
import 'package:ten_twenty/ui/MovieDetailed.dart';
import 'package:ten_twenty/ui/splash.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "MainNavigator");

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0x0ff26242e),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MultiProvider(
      child: OrientationBuilder(
        builder: (ctx, orientation) {
          return Consumer<AppThemeNotifier>(
            builder: (_, themeProvider, __) {
              themeProvider.changeOrientation(orientation);
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                title: "TenTwenty",
                onGenerateRoute: RouteGenerator.generateRoute,
                initialRoute: SplashScreen.Route,
                routes: {
                  SplashScreen.Route: (context) => SplashScreen(),
                  MovieDetailedScreen.Route: (context) => MovieDetailedScreen(),
                },
                builder: BotToastInit(),
                navigatorObservers: [
                  BotToastNavigatorObserver(),
                  routeObserver,
                ],
                themeMode: themeProvider.currentThemeMode,
                theme: themeProvider.appLightTheme,
                darkTheme: themeProvider.appDarkTheme,
              );
            },
          );
        },
      ),
      providers: [
        ChangeNotifierProvider<AppThemeNotifier>(create: (BuildContext ctx) => AppThemeNotifier()),
        ChangeNotifierProvider<HomeScreenController>(create: (BuildContext ctx) => HomeScreenController()),
        ChangeNotifierProvider<MovieListController>(create: (BuildContext ctx) => MovieListController()),
      ],
    );
  }
}
