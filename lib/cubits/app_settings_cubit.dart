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
    shadowColor: Colors.grey,
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
  );

  final ThemeData _lightTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade200),
    fontFamily: "Segoe UI",
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    highlightColor: Colors.white,
    shadowColor: Colors.grey,
    errorColor: Colors.red,
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.grey,
        primaryColorDark: Colors.white,
        accentColor: Colors.white,
        backgroundColor: Colors.white,
        cardColor: Colors.white,
        brightness: Brightness.light),
    backgroundColor: Colors.grey.shade300,
    scaffoldBackgroundColor: Colors.white,
  );

  Future<ThemeData> initialize() async {
    SharedPreferences.setMockInitialValues({});
    _preferences = await SharedPreferences.getInstance();
    var darkTheme = _preferences.getBool('dark_theme');
    currentTheme = darkTheme != null && !darkTheme ? _lightTheme : _darkTheme;
    darkTheme = currentTheme == _darkTheme;

    return currentTheme;
  }

  switchTheme(bool darkTheme) {
    currentTheme = darkTheme ? _darkTheme : _lightTheme;
    this.darkTheme = darkTheme;
    _preferences.setBool('dark_theme', darkTheme);
    emit(SettingsState(theme: currentTheme));
  }
}
