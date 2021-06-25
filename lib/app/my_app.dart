import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/language_controller.dart';
import 'package:gmt_planter/controllers/version_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/internationalization/app_localization.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/ui/screens/dashboard/screen_dashboard.dart';
import 'package:gmt_planter/ui/screens/login/screen_login.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      builder: (_, __) {
        return Consumer<LanguageNotifier>(
          builder: (_, notifier, __) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: getThemeData(context: context),
            darkTheme: getThemeData(context: context),
            locale: notifier.appLocale,
            supportedLocales: const [
              kLocaleIn,
              kLocaleEn,
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: Consumer<VersionControler>(
              builder: (context, value, child) {
                subscribe(context);
                switch (value.state) {
                  case NotifierState.initial:
                    value.getVersions(context);
                    return Container();
                  case NotifierState.fetching:
                    return Scaffold(body: getPlatformProgress());
                  case NotifierState.loaded:
                    return FutureBuilder<List<bool>>(
                      future: Future.wait([_getScreen(), letUserIn(value.model)]),
                      builder: (context, snapshot) {
                        print(snapshot);
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            final getScreen = snapshot.data[0];
                            final letUserIn = snapshot.data[1];

                            if (!letUserIn) {
                              return Scaffold(
                                body: getErrorUI(
                                  context: context,
                                  message: kDescriptionUpdateApp,
                                  action: kButtonUpdate,
                                  callback: () => gotoStores(),
                                ),
                              );
                            }

                            return getScreen ? ScreenDashboard() : ScreenLogin();
                          default:
                            return Scaffold(
                              body: Center(child: getPlatformProgress()),
                            );
                        }
                      },
                    );

                  case NotifierState.error:
                    return getErrorUI(context: context, callback: () => value.getVersions(context));
                  default:
                    return Container();
                }
              },
            ),
            routes: routes,
          ),
        );
      },
    );
  }

  void subscribe(BuildContext context) {
    final topic = kReleaseMode ? kTopicProd : kTopicDev;
    FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}

ThemeData getThemeData({@required BuildContext context}) {
  return ThemeData(
      brightness: Brightness.light,
      elevatedButtonTheme: buttonThemeData,
      primaryColor: kColorPrimary,
      primaryColorDark: kColorPrimaryDark,
      accentColor: kColorAccent,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black),
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey),
      ));
}

final buttonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStateProperty.resolveWith(
      (states) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36),
      ),
    ),
    padding: MaterialStateProperty.resolveWith(
      (states) => const EdgeInsets.symmetric(vertical: 16, horizontal: 46),
    ),
    backgroundColor: MaterialStateColor.resolveWith((states) => kColorPrimary),
  ),
);

final ButtonThemeData buttonThemeData2 = ButtonThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(36),
  ),
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 46),
  disabledColor: Colors.grey,
  buttonColor: kColorPrimary,
  focusColor: kColorPrimary,
);

Future<bool> _getScreen() async {
  return await getToken() != null;
}
