import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:superchat/common/data/SpUtils.dart';
import 'package:superchat/util/firebase_options.dart';

class Config {
  static Future init(Function() runApp) async {
    // Initialize the config
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await SpUtil.getInstance();

    runApp();
  }
}
