// ignore_for_file: constant_identifier_names, unused_field

// import 'package:sp_util/sp_util.dart';
// import 'package:dinasty/models/login_certificate.dart';
// import 'package:dinasty/utils/SpUtils.dart';
// import 'package:flutter_openim_widget/flutter_openim_widget.dart';
// import 'package:sprintf/sprintf.dart';

// import '../models/login_certificate.dart';

import 'package:superchat/common/data/SpUtils.dart';
import 'package:superchat/model/users.dart';

class DataPersistence {
  static const _ACCOUNT = 'account';
  static const _DARK_MODE = "darkMode";

  DataPersistence._();

  static bool get isDark =>
      SpUtil.getBool(_DARK_MODE, defValue: false) ?? false;

  static setDarkMode(bool isdarkMode) {
    SpUtil.putBool(_DARK_MODE, isdarkMode);
  }

  static UsersModel? getAccount() {
    return SpUtil.getObj(_ACCOUNT, (v) => UsersModel.fromJson(v.cast()));
  }

  static Future<bool>? removeAccount() {
    return SpUtil.remove(_ACCOUNT);
  }

  static Future<bool>? putAccount(UsersModel map) {
    return SpUtil.putObject(_ACCOUNT, map.toJson());
  }
}
