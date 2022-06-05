import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fokad_admin/src/constants/role_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isLightMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.light;
    } else {
      return themeMode == ThemeMode.light;
    }
  }

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.dark(
      primary: Colors.amber.shade700,
    ),
    // textButtonTheme: TextButtonThemeData(
    //   style: ButtonStyle(
    //     elevation: MaterialStateProperty.all(5.0),
    //     shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
    //       return RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(30.0));
    //     }),
    //     textStyle: MaterialStateProperty.all(
    //       const TextStyle(
    //       color: Colors.white,
    //     )),
    //   foregroundColor: MaterialStateProperty.all(Colors.amber),
    // )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(5.0),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0));
        }),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            color: Colors.white,
          )
        ),
        backgroundColor: MaterialStateProperty.all(Colors.amber),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: Colors.blue.shade50,
    primaryColor: Colors.white,
    primarySwatch: roleThemeSwatch(1),
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.light(
      primary: Colors.amber.shade700,
    ),
    // iconTheme: const IconThemeData(color: Colors.orange, opacity: 0.8),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   foregroundColor: Colors.white,
    //   backgroundColor: Colors.amber.shade700
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(5.0),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0));
        }),
        textStyle: MaterialStateProperty.all(const TextStyle(
          color: Colors.white,
        )),
        backgroundColor: MaterialStateProperty.all(Colors.amber.shade700),
      ),
    ),
    // visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
