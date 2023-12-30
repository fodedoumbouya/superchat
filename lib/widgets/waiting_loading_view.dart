import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingView {
  BuildContext context;

  LoadingView({required this.context});

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  Future<T> wrap<T>({required Future<T> Function() asyncFunction}) async {
    show();
    T data;
    try {
      data = await asyncFunction();
    } on Exception catch (_) {
      rethrow;
    } finally {
      dismiss();
    }
    return data;
  }

  void show() async {
    if (_isVisible) return;
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Center(
          child: SpinKitCircle(
            color: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
    );
    _isVisible = true;
    _overlayState?.insert(_overlayEntry!);
  }

  dismiss() async {
    if (!_isVisible) return;
    _isVisible = false;
    _overlayEntry?.remove();
  }
}
