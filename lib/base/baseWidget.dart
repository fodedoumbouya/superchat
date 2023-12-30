import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superchat/util/adapterHelper/responsive_sizer.dart';
import 'package:superchat/util/myLog.dart';
import 'package:superchat/widgets/custom/customTextWidget.dart';

typedef FunctionBoolCallback = void Function(bool o);

abstract class BaseWidget extends ConsumerStatefulWidget {
  const BaseWidget({super.key});

  @override
  BaseWidgetState createState() {
    return getState();
  }

  BaseWidgetState getState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends ConsumerState<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // AppLog.v("didChangeDependencies: ${widget.toString()}\n");
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.paused) {}
  }

  /// Return background color always blue
  Color bc() {
    return Theme.of(context).colorScheme.background;
  }

// Return  color always grey
  Color bcGrey() {
    return const Color.fromRGBO(98, 99, 102, 1);
  }

  /// return White/Black on theme mode (light/dark)
  Color bp() {
    return Theme.of(context).primaryColor;
  }

  /// return Black/White on theme mode (light/dark)
  Color bd() {
    return Theme.of(context).colorScheme.primaryContainer;
  }

  Color bpLight() {
    return Theme.of(context).colorScheme.primary;
  }

// return empty SizedBox with tiny space
  // Widget get sb => const SizedBox.shrink();

  double sw() {
    return Device.width;
  }

  double sh() {
    return Device.height;
  }

  Future toPage(Widget w) {
    AppLog.d("Moving to page: ${w.toStringShallow()}\n");
    return Navigator.of(context).push(MaterialPageRoute(builder: (con) {
      return w;
    }));
  }

  void jumpToPage(Widget w) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (con) {
      return w;
    }));
  }

  void jumpToFirstPage() {
    Navigator.popUntil(
        context, ModalRoute.withName(Navigator.defaultRouteName));
  }

  void pop([Object? o]) {
    Navigator.of(context).pop(o);
  }

  rebuidState() {
    if (mounted) {
      setState(() {});
    }
  }

  // / show dialog
  // / [title] dialog title
  // / [content] dialog content
  // / [actions] dialog actions
  // / [barrierDismissible] dialog barrierDismissible
  showMyDialog({
    required String title,
    required String content,
    String confirmTxt = "OK",
    String cancelTxt = "Cancel",
    Color? txtColor = Colors.red,
    Color? contentColor,
    required void Function() onCancel,
    required void Function() onConfirm,
  }) {
    return showAdaptiveDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog.adaptive(
              title: CustomTextWidget(title, color: txtColor),
              content: CustomTextWidget(content,
                  withOverflow: false, color: contentColor ?? bd()),
              actions: [
                TextButton(
                  onPressed: () {
                    pop();
                    onCancel();
                  },
                  child: CustomTextWidget(cancelTxt, color: bc()),
                ),
                TextButton(
                  onPressed: () {
                    pop();
                    onConfirm();
                  },
                  child: CustomTextWidget(confirmTxt, color: txtColor),
                ),
              ],
            ));
  }

  /// --------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: baseBuild(context),
    );
  }

  baseBuild(BuildContext context) {}
}
