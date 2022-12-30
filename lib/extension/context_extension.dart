import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

extension ContextExtension on BuildContext {
  bool get isHaveBottomNotch => window.viewPadding.bottom > 0 && Platform.isIOS;

  Size get screenSize => MediaQuery.of(this).size;

  void unfocus() => FocusScope.of(this).unfocus();
}

void changeTheme(bool isLightTheme) {
  final _mySystemTheme = isLightTheme
      ? SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Constants.colorOnSurface)
      : SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.dark, statusBarColor: Colors.black);
  SystemChrome.setSystemUIOverlayStyle(_mySystemTheme);
}
