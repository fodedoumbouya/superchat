import 'package:flutter/material.dart';
import 'package:superchat/util/adapterHelper/responsive_sizer.dart';
import 'package:superchat/widgets/custom/customTextWidget.dart';

class ConfirmButton extends StatelessWidget {
  final String txt;
  final double allM;
  final double txtSize;
  final double? h;
  final Color? bColor;
  final void Function() onPressed;

  const ConfirmButton({
    super.key,
    required this.txt,
    this.allM = 16.0,
    this.txtSize = 20.0,
    this.h,
    this.bColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(allM),
      height: h ?? 5.h, // 5.h = 5%
      width: 100.w, // 100.w = 100%
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bColor ?? Colors.blue),
        ),
        onPressed: onPressed,
        child: CustomTextWidget(txt,
            color: Theme.of(context).primaryColor, size: txtSize),
      ),
    );
  }
}
