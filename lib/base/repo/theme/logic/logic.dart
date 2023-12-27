import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superchat/base/baseStateNotifier.dart';
import 'package:superchat/base/repo/theme/model/model.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>(
  (_) => ThemeNotifier(),
);

class ThemeNotifier extends BaseStateNotifier<ThemeState> {
  ThemeNotifier() : super(ThemeState(isDarkMode: false));

  setTheme({required bool isDarkMode}) {
    state = ThemeState(isDarkMode: isDarkMode);
  }
}
