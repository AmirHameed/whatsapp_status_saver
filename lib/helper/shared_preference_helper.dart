import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _sharedPreferences;

@immutable
class SharedPreferenceHelper {
  static const String _USER = 'SharedPreferenceHelper._user';

  static const SharedPreferenceHelper _instance = SharedPreferenceHelper._();

  const SharedPreferenceHelper._();

  factory SharedPreferenceHelper() => _instance;

  static Future<void> initializeSharedPreferences() async => _sharedPreferences = await SharedPreferences.getInstance();

  bool get isUserLoggedIn => _sharedPreferences?.containsKey(_USER) ?? false;

  Future<void> clear() async => _sharedPreferences?.clear();
}