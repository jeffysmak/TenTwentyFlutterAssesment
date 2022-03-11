import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ten_twenty/theme/AppThemeTexts.dart';

class AppThemeNotifier extends ChangeNotifier {
  bool isDarkTheme = false;
  late Orientation _currentOrientation;

  void changeOrientation(Orientation orientation) {
    this._currentOrientation = orientation;
    notifyListeners();
  }

  bool get isScreenWider => _currentOrientation == Orientation.landscape;

  static List<Color> colors = [
    definedColor1,
    definedColor4,
    definedColor6,
    definedColor7,
    definedColor8,
    definedColor9,
    ppColorGreen,
    appColorRed,
  ];

  static Color materialBackground = Color(0x0ffA6A6A6);

  static Color definedColor1 = Color(0x0ff2E2739);
  static Color definedColor2 = Color(0x0ffF6F6FA);
  static Color definedColor3 = Color(0x0ff827D88);
  static Color definedColor4 = Color(0x0ff61C3F2);
  static Color definedColor5 = Color(0x0ffDBDBDF);
  static Color definedColor6 = Color(0x0ff15D2BC);
  static Color definedColor7 = Color(0x0ffE26CA5);
  static Color definedColor8 = Color(0x0ff564CA3);
  static Color definedColor9 = Color(0x0ffCD9D0F);

  static Color scaffoldBackgroud = Color(0x0ffF6F6FA); //->
  static Color scaffoldBackgroudDark = Color(0x0ff13131A);

  static Color iconColorOnLight = Color(0x0ff000000);

  static Color primaryLight = Color(0x0ffffffff);
  static Color primaryDark = Color(0x0ff1C1C24);

  static Color textColorOnLight = Color(0x0ff202C43);
  static Color textColorOnLightDark = Color(0x0ff171725);

  static Color textColorOnDark = Color(0x0ffFAFAFB);
  static Color textColorOnDarkLight = Color(0x0ffffffff);

  // static Color textColorSubtext2 = Color(0x0ff696974);
  static Color textColorSubtext2 = Color(0x0ff8F8F8F);
  static Color textColorLight = Color(0x0ff92929d);

  // static Color textColorVeryLight = Color(0x0ffd5d5dc);
  static Color textColorVeryLight = Color(0x0ffDBDBDF);
  static Color inputFieldFillColorLight = Color(0x0ffd5d5dc);

  static Color inputFieldFillColorDark = Color(0x0ff292932);
  static Color accentColor = Color(0x0ff33d8a1);

  static Color appColorYellow = Color(0x0ffffc542);
  static Color ppColorGreen = Color(0x0ff15D2BC);
  static Color appColorRed = Color(0x0fffc5a5a);
  static Color outlineBorderColor = Color(0x0ff000000);
  static Color outlineBorderColorDark = Color(0x0ff44444F);
  static Color fieldHintTextColor = Color(0x0ffB5B5BE);

  // icon color 92929D

  static const inputBorderRadius = 10.0;

  ThemeMode get currentThemeMode => isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    this.isDarkTheme = !this.isDarkTheme;
    notifyListeners();
  }

  ThemeData get appLightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: scaffoldBackgroud,
        primaryColor: primaryLight,
        accentColor: accentColor,
        iconTheme: IconThemeData(color: textColorLight),
        appBarTheme: AppBarTheme(elevation: 1, centerTitle: false),
        colorScheme: ColorScheme.light(
          primary: primaryLight,
          secondary: accentColor,
          onPrimary: textColorOnLight,
          onSecondary: primaryLight,
          background: scaffoldBackgroud,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
            textStyle: MaterialStateProperty.all(buttonText),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(inputBorderRadius)),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
            textStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return buttonText.copyWith(color: Colors.grey);
              }
              return buttonText.copyWith(color: scaffoldBackgroudDark);
            }),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius + 6),
          ),
          elevation: 0,
          color: primaryLight,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: captionStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: captionStyle.copyWith(fontSize: 10),
          unselectedItemColor: primaryLight.withOpacity(0.54),
          selectedItemColor: primaryLight,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius),
            borderSide: BorderSide(color: outlineBorderColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius),
            borderSide: BorderSide(color: outlineBorderColor),
          ),
          errorStyle: TextStyle(height: 0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintStyle: TextStyle().copyWith(color: fieldHintTextColor),
          labelStyle: TextStyle().copyWith(color: fieldHintTextColor),
        ),
        dividerColor: outlineBorderColor.withOpacity(0.11),
        textTheme: TextTheme(
          headline1: heading1Style.copyWith(
            color: textColorOnLight,
          ),
          headline2: heading2Style.copyWith(
            color: textColorOnLight,
          ),
          headline3: heading3Style.copyWith(
            color: textColorOnLight,
          ),
          headline4: heading4Style.copyWith(
            color: textColorOnLight,
          ),
          headline5: heading5Style.copyWith(
            color: textColorOnLight,
          ),
          headline6: heading6Style.copyWith(
            color: textColorOnLight,
          ),
          subtitle1: buttonText.copyWith(
            color: textColorOnLight,
          ),
          // subtitle1: subHeading.copyWith(
          //   color: textColorLight,
          // ),
          bodyText2: buttonText.copyWith(
            // color: textColorLight,
            color: textColorSubtext2,
          ),
          bodyText1: bodyStyle.copyWith(
            color: textColorOnLight,
          ),
          caption: captionStyle.copyWith(
            color: textColorVeryLight,
          ),
          // button: buttonText,
          button: buttonText.copyWith(
            color: textColorOnLightDark,
            // color: textColorLight,
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: scaffoldBackgroud,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius),
          ),
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return textColorLight;
            }
            return accentColor;
          }),
        ),
      );

  ThemeData get appDarkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: scaffoldBackgroudDark,
        primaryColor: primaryDark,
        accentColor: accentColor,
        iconTheme: IconThemeData(color: textColorLight),
        appBarTheme: AppBarTheme(
          backgroundColor: scaffoldBackgroudDark,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          brightness: Brightness.light,
        ),
        colorScheme: ColorScheme.dark(
          primary: accentColor,
          secondary: accentColor,
          onPrimary: primaryLight,
          onSecondary: primaryLight,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
            textStyle: MaterialStateProperty.all(buttonText),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(inputBorderRadius)),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
            textStyle: MaterialStateProperty.resolveWith(
              (states) {
                if (states.contains(MaterialState.disabled)) {
                  return buttonText.copyWith(color: Colors.grey);
                }
                return buttonText.copyWith(color: scaffoldBackgroudDark);
              },
            ),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius + 6),
          ),
          elevation: 0,
          color: primaryDark,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: primaryDark),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          fillColor: inputFieldFillColorDark,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          errorStyle: TextStyle(height: 0),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintStyle: TextStyle().copyWith(color: fieldHintTextColor),
          labelStyle: TextStyle().copyWith(color: fieldHintTextColor),
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius),
          ),
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return textColorLight;
            }
            return accentColor;
          }),
        ),
        dividerColor: outlineBorderColorDark,
        textTheme: TextTheme(
          headline1: heading1Style.copyWith(
            color: textColorOnDark,
          ),
          headline2: heading2Style.copyWith(
            color: textColorOnDark,
          ),
          headline3: heading3Style.copyWith(
            color: textColorOnDark,
          ),
          headline4: heading4Style.copyWith(
            color: textColorOnDark,
          ),
          headline5: heading5Style.copyWith(
            color: textColorOnDark,
          ),
          headline6: heading6Style.copyWith(
            color: textColorOnDark,
          ),
          subtitle1: buttonText.copyWith(
            color: textColorOnDark,
          ),
          // subtitle1: subHeading.copyWith(
          //   color: textColorOnDark,
          // ),
          bodyText2: buttonText.copyWith(
            // color: textColorOnDark,
            color: textColorSubtext2,
          ),
          bodyText1: bodyStyle.copyWith(
            color: textColorOnDark,
          ),
          caption: captionStyle.copyWith(
            color: textColorVeryLight,
          ),
          // button: buttonText,
          button: buttonText.copyWith(
            // color: textColorOnDark,
            color: textColorOnDarkLight,
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: scaffoldBackgroudDark,
        ),
      );
}
