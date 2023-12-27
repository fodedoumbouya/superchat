import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superchat/base/baseStateNotifier.dart';
import 'package:superchat/base/repo/theme/logic/logic.dart';
import 'package:superchat/base/repo/theme/model/model.dart';
import 'package:superchat/pages/home.dart';
import 'package:superchat/pages/login/sign_in_page.dart';
import 'package:superchat/util/adapterHelper/responsive_sizer.dart';
import 'package:superchat/util/styles/theme.dart';

class Root extends ConsumerWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ecouter le mode de l'application si l'application est dark/light mode pour changer le theme de l'application
    final ThemeState themeState = themeProvider.getState(ref);
    ThemeMode mode;
    if (themeState.isDarkMode) {
      mode = ThemeMode.dark;
    } else {
      mode = ThemeMode.light;
    }
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    Widget w;
    if (isLoggedIn) {
      w = const HomePage();
    } else {
      w = const SignInPage();
    }

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: "SuperChat",
          theme: ZTheme.lightTheme(),
          darkTheme: ZTheme.dartTheme(),
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          home: w,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
