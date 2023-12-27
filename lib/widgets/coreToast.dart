import 'package:flutter_easyloading/flutter_easyloading.dart';

class CoreToast {
  CoreToast._();

  static Future showToast(String msg, {Duration? duration}) {
    if (msg.trim().isNotEmpty) {
      return EasyLoading.showToast(msg, duration: duration);
    } else {
      return Future.value();
    }
  }

  static Future showProgress(double progress,
      {String? status, EasyLoadingMaskType? maskType}) {
    return EasyLoading.showProgress(progress,
        status: status, maskType: maskType);
  }

  static Future showSuccess(String msg, {Duration? duration}) {
    return EasyLoading.showSuccess(msg, duration: duration);
  }

  static Future showError(String msg,
      {Duration? duration, EasyLoadingMaskType? maskType}) {
    return EasyLoading.showError(msg, duration: duration, maskType: maskType);
  }

  static Future showInfo(String msg, {Duration? duration}) {
    return EasyLoading.showInfo(msg, duration: duration);
  }

  static Future dismiss() {
    return EasyLoading.dismiss();
  }
}
