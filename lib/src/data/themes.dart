import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Schemes {
  ColorScheme colorSchemeOne = ColorScheme(
      brightness: Brightness.light,
      primaryContainer: Color(0xff03a9f4),
      secondaryContainer: Color(0xff9c27b0),
      primary: Colors.orange,
      secondary: Color(0xff9c27b0),
      background: Color.fromARGB(255, 127, 24, 146),
      surface: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.orange,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      error: Colors.red.shade400);

  ColorScheme colorSchemeTwo = ColorScheme(
      brightness: Brightness.light,
      primaryContainer: Color(0xff3f5efb),
      secondaryContainer: Color(0xfffc466b),
      primary: Colors.white,
      secondary: Colors.orange,
      background: Colors.black,
      surface: Colors.white,
      onBackground: Colors.black38,
      onSurface: Colors.white,
      onError: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.orange,
      error: Colors.red.shade400);
}

class Themes {
  final themeOne = ThemeData.from(colorScheme: Schemes().colorSchemeOne);
  final themeTwo = ThemeData.from(colorScheme: Schemes().colorSchemeTwo);
}

class ThemesModel extends ChangeNotifier {
  ThemeData currentTheme = Themes().themeOne;

  void changeTheme(ThemeData theme) {
    currentTheme = theme;
    notifyListeners();
  }
}
