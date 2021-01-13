import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: getThemeData(context: context),
          darkTheme: getThemeData(context: context),
          home: Builder(
            builder: (context) {
              return FutureBuilder<bool>(
                future: _getScreen(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return snapshot.data ? ScreenDashboard() : ScreenLogin();
                    default:
                      return Scaffold(
                        body: Center(child: getPlatformProgress()),
                      );
                  }
                },
              );
            },
          ),
          routes: routes,
        );
      },
    );
  }
}

ThemeData getThemeData({@required BuildContext context}) {
  return ThemeData(
      brightness: Brightness.light,
      buttonTheme: buttonThemeData,
      primaryColor: kColorPrimary,
      primaryColorDark: kColorPrimaryDark,
      accentColor: kColorAccent,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle:
            Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black),
        unselectedLabelStyle:
            Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey),
      ));
}

final ButtonThemeData buttonThemeData = ButtonThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(36),
  ),
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 46),
  disabledColor: Colors.grey,
  buttonColor: kColorPrimary,
  focusColor: kColorPrimary,
);

Future<bool> _getScreen() async {
  return false;
  return await getToken() != null;
}
