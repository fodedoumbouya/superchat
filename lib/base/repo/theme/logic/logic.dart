import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superchat/base/baseStateNotifier.dart';
import 'package:superchat/base/repo/theme/model/model.dart';
import 'package:superchat/common/data/data_persistence.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>(
  (_) {
    // get user data from the local storage to the userState for the app
    final isDark = DataPersistence.isDark;

    return ThemeNotifier(theme: ThemeState(isDarkMode: isDark));
  },
);

class ThemeNotifier extends BaseStateNotifier<ThemeState> {
  ThemeState theme;
  ThemeNotifier({required this.theme}) : super(theme);

  get getTheme => state;

  setTheme({required bool isDarkMode}) {
    state = ThemeState(isDarkMode: isDarkMode);
    DataPersistence.setDarkMode(isDarkMode);
  }
}
