import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_status_saver/translation/codegen_loader.g.dart';
import 'package:whatsapp_status_saver/ui/fullImage/full_image_screen.dart';
import 'package:whatsapp_status_saver/ui/fullImage/full_image_screen_bloc.dart';
import 'package:whatsapp_status_saver/ui/mainScreen/main_screen.dart';
import 'package:whatsapp_status_saver/ui/mainScreen/main_screen_bloc.dart';
import 'package:whatsapp_status_saver/ui/play_status.dart';
import 'package:whatsapp_status_saver/ui/preminum/premium_screen.dart';
import 'package:whatsapp_status_saver/ui/preminum/premium_screen_bloc.dart';
import 'package:whatsapp_status_saver/ui/splash_screen.dart';
import 'package:whatsapp_status_saver/utils/app_strings.dart';
import 'package:whatsapp_status_saver/utils/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final deviceLocale = Platform.localeName;
  final countryLanguage = deviceLocale.split('_')[0];

  runApp(EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('en'), Locale('ar')],
      assetLoader: const CodegenLoader(),
      startLocale: Locale(countryLanguage),
      fallbackLocale: Locale(countryLanguage),
      child: const _App()));

}

final _mySystemTheme = SystemUiOverlayStyle.light.copyWith(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    statusBarColor: Constants.colorOnSurface);

const _colorScheme = ColorScheme(
    primary: Constants.colorPrimary,
    primaryContainer: Constants.colorPrimaryVariant,
    secondary: Constants.colorSecondaryVariant,
    secondaryContainer: Constants.colorSecondaryVariant,
    surface: Constants.colorSurface,
    background: Constants.colorBackground,
    error: Constants.colorError,
    onPrimary: Constants.colorOnPrimary,
    onSecondary: Constants.colorOnSecondary,
    onSurface: Constants.colorOnSurface,
    onBackground: Constants.colorOnBackground,
    onError: Constants.colorOnError,
    brightness: Brightness.light);

ThemeData _buildAppThemeData() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      colorScheme: _colorScheme,
      primaryColor: Constants.colorPrimary,
      unselectedWidgetColor: Constants.colorOnIcon,
      scaffoldBackgroundColor: Constants.colorOnSurface,
      errorColor: Constants.colorError);
}

class _AppRouter {
  Route _getPageRoute(Widget screen) => Platform.isIOS
      ? CupertinoPageRoute(builder: (_) => screen)
      : MaterialPageRoute(builder: (_) => screen);

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.route:
        {
          const screen = SplashScreen();
          return _getPageRoute(screen);
        }
        case PlayStatus.route:
        {
          final  argument=settings.arguments as List<dynamic>;
          String imagePath=argument.first as String;
          bool isSave=argument.last as bool;
          final  screen = PlayStatus(videoFile: imagePath,isSaved: isSave);
          return _getPageRoute(screen);
        }
      case FullImageScreen.route:
        {

          final  argument=settings.arguments as List<dynamic>;
          String imagePath=argument.first as String;
          bool isSave=argument.last as bool;
          final screen = FullImageScreen(imagePath: imagePath,isSaved: isSave,);
          return _getPageRoute(BlocProvider(
            create: (_) => FullImageScreenBloc(),
            child: screen,
          ));
        }

      case PremiumScreen.route:
        {
          const screen = PremiumScreen();
          return _getPageRoute(BlocProvider(
            create: (_) => PremiumScreenBloc(),
            child: screen,
          ));
        }      case MainScreen.route:
        {
          const screen = MainScreen();
          return _getPageRoute(MultiBlocProvider(providers: [
            BlocProvider(create: (_) => MainScreenBloc()),
          ], child: screen));
        }
    }
    return null;
  }

  void dispose() {}
}

class _App extends StatefulWidget {
  const _App();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> with WidgetsBindingObserver{
  final _AppRouter __appRouter = _AppRouter();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(_mySystemTheme);
    super.initState();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    _setLanguage();
    super.didChangeLocales(locales);
  }

  void _setLanguage() async {
    final deviceLocale = Platform.localeName;
    final countryLanguage = deviceLocale.split('_')[0];
    if (countryLanguage == 'ar') {
      await context.setLocale(const Locale('ar'));
    } else {
      await context.setLocale(const Locale('en'));
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: AppText.APP_NAME,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: __appRouter.onGenerateRoute,
        theme: _buildAppThemeData());
  }

  @override
  void dispose() {
    __appRouter.dispose();
    super.dispose();
  }
}
