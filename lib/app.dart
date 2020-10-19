import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailandcalendaruppa/calendar/param/route_key.dart';
import 'package:mailandcalendaruppa/calendar/param/route_key.dart';
import 'package:mailandcalendaruppa/calendar/ui/about/aboutscreen.dart';
import 'package:mailandcalendaruppa/calendar/ui/about/licences/licences.dart';
import 'package:mailandcalendaruppa/calendar/ui/help/help.dart';
import 'package:mailandcalendaruppa/calendar/ui/principal//home.dart';
import 'package:mailandcalendaruppa/calendar/ui/login/login.dart';
import 'package:mailandcalendaruppa/calendar/ui/onboarding/onboarding.dart';
import 'package:mailandcalendaruppa/calendar/ui/settings/settings.dart';
import 'package:mailandcalendaruppa/calendar/ui/splash/splashscreen.dart';
import 'package:mailandcalendaruppa/calendar/ui/support/supportme.dart';
import 'package:mailandcalendaruppa/calendar/utils/custom_route.dart';
import 'package:mailandcalendaruppa/calendar/utils/functions.dart';
import 'package:mailandcalendaruppa/calendar/utils/preferences.dart';
import 'package:mailandcalendaruppa/calendar/utils/translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mailandcalendaruppa/mail/ui/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

final routes = {
  RouteKey.SPLASHSCREEN: SplashScreen(),
  RouteKey.HOME: HomeScreen(),
  RouteKey.SETTINGS: SettingsScreen(),
  RouteKey.HELP: HelpScreen(),
  RouteKey.ABOUT: AboutScreen(),
  RouteKey.LICENCES: LicencesScreen(),
  RouteKey.INTRO: OnboardingScreen(),
  RouteKey.LOGIN: LoginScreen(),
  RouteKey.SUPPORTME: SupportMeScreen(),
};

class App extends StatelessWidget {
  final SharedPreferences prefs;

  const App({Key key, /*@required*/ this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferencesProvider(
      prefs: prefs,
      child: Builder(
        builder: (context) {
          final themePrefs = PreferencesProvider.of(context).theme;
          final theme = ThemeData(
            platform: TargetPlatform.android,
            fontFamily: 'GoogleSans',
            brightness: getBrightness(themePrefs.darkTheme),
            primaryColor: themePrefs.primaryColor,
            accentColor: themePrefs.accentColor,
            toggleableActiveColor: themePrefs.accentColor,
            textSelectionHandleColor: themePrefs.accentColor,
          );

          SystemUiOverlayStyle style = theme.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark;

          SystemChrome.setSystemUIOverlayStyle(style.copyWith(
            statusBarColor: Colors.transparent,
          ));

          return MaterialApp(
            title: "UPPA Edt & Mail",
            theme: theme,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: i18n.supportedLocales(),
            initialRoute: RouteKey.SPLASHSCREEN,
            onGenerateRoute: (RouteSettings settings) {
              if (routes.containsKey(settings.name))
                return CustomRoute(
                  builder: (_) => routes[settings.name],
                  settings: settings,
                );
              assert(false);
              return null;
            },
          );
        },
      ),
    );
  }
}
