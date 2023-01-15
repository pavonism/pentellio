import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  SettingsState({required this.theme});
  ThemeData theme;
}

class AppSettingsCubit extends Cubit<SettingsState> {
  AppSettingsCubit() : super(SettingsState(theme: _darkTheme));

  bool darkTheme = true;
  late SharedPreferences _preferences;
  late ThemeData currentTheme;

  static final ThemeData _darkTheme = ThemeData(
      fontFamily: "Segoe UI",
      primarySwatch: Colors.grey,
      primaryColor: Colors.white,
      highlightColor: Colors.white,
      shadowColor: Colors.black87,
      errorColor: Colors.red,
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
          primaryColorDark: const Color(0xFF282E33),
          accentColor: Colors.white,
          backgroundColor: const Color(0xFF282E33),
          cardColor: const Color(0x003D444B),
          brightness: Brightness.dark),
      backgroundColor: const Color(0xFF282E33),
      scaffoldBackgroundColor: const Color(0xFF191C1F),
      indicatorColor: Color.fromARGB(217, 41, 177, 98));

  final ThemeData _lightTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade200),
    fontFamily: "Segoe UI",
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    highlightColor: Colors.black,
    shadowColor: Colors.black12,
    errorColor: Colors.red,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.grey,
      primaryColorDark: Colors.black,
      accentColor: Colors.black,
      backgroundColor: Colors.white,
      cardColor: Colors.black,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(labelMedium: TextStyle(color: Colors.black)),
    backgroundColor: Colors.grey.shade300,
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Color.fromARGB(217, 41, 177, 98),
  );

  Future<ThemeData> initialize() async {
    SharedPreferences.setMockInitialValues({});
    _preferences = await SharedPreferences.getInstance();
    var darkTheme = _preferences.getBool('dark_theme');
    // currentTheme = darkTheme != null && !darkTheme ? _lightTheme : _darkTheme;
    currentTheme = _lightTheme;
    darkTheme = currentTheme == _darkTheme;
    emit(SettingsState(theme: currentTheme));
    return currentTheme;
  }

  switchTheme(bool darkTheme) {
    currentTheme = darkTheme ? _darkTheme : _lightTheme;
    this.darkTheme = darkTheme;
    _preferences.setBool('dark_theme', darkTheme);
    emit(SettingsState(theme: currentTheme));
  }

  Future setSketchesCompression(double compressionRatio) async {
    await _preferences.setDouble('skecthes_compression', compressionRatio);
  }

  double getCompressionRatio() {
    return _preferences.getDouble('skecthes_compression') ?? 0.25;
  }
}
