// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:superchat/util/firebase_options.dart';

// import 'chat_app.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(const ProviderScope(child: ChatApp()));
// }

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superchat/config/config.dart';
import 'package:superchat/pages/root.dart';
import 'package:superchat/util/myLog.dart';

Future<void> main() async {
  //
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (kDebugMode || kProfileMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runZonedGuarded(
    () {
      Config.init(() => runApp(const ProviderScope(child: Root())));
    },
    (Object error, StackTrace stackTrace) {
      AppLog.d("Error FROM OUT_SIDE FRAMEWORK ");
      AppLog.d("--------------------------------");
      AppLog.d("Error :  $error");
      AppLog.d("StackTrace :  $stackTrace");
    },
  );
}
