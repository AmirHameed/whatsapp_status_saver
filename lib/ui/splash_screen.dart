import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_status_saver/extension/context_extension.dart';
import 'package:whatsapp_status_saver/translation/locale_keys.g.dart';
import 'package:whatsapp_status_saver/utils/constants.dart';

import 'mainScreen/main_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String route = '/';

  const SplashScreen();

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2500)).then((_) {
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.route, (_) => false);
    });
    final size = context.screenSize;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
        backgroundColor: Constants.colorSurface,
        body: Container(
            width: size.width,
            height: size.height,
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const Image(
                  image: AssetImage(
                    'assets/splash.png',
                  ),
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  LocaleKeys.WHATS_APP_STATUS_SAVER.tr(),
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 22, color: Constants.colorOnSurface),
                )
              ],
            )));
  }
}
