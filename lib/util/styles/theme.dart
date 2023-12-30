import 'package:flutter/material.dart';
import 'package:superchat/util/styles/colors.dart';

class ZTheme {
  ZTheme._();

  static dartTheme() {
    return ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Colors.black,
      indicatorColor: const Color(0xFF0E1D36),
      hintColor: const Color(0x90909090),
      highlightColor: const Color(0xFF372901),
      hoverColor: const Color.fromARGB(180, 26, 26, 75),
      focusColor: const Color(0xFF0B2512),
      disabledColor: Colors.grey,
      cardColor: const Color(0xFF151515),
      canvasColor: Colors.black,
      brightness: Brightness.dark,
      buttonTheme: const ButtonThemeData(colorScheme: ColorScheme.dark()),
      appBarTheme: const AppBarTheme(
        backgroundColor: ZColors.bc,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: ZColors.inputBorderColor,
              width: 5,
              style: BorderStyle.solid),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ZColors.inputBorderColorFocused,
            width: 5,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ZColors.inputBorderColorError,
            width: 5,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ZColors.inputBorderColorError,
            width: 1,
          ),
        ),
      ),
      colorScheme:
          ColorScheme.fromSwatch(primarySwatch: ZColors.primarySwatch).copyWith(
        background: Colors.blue,
        primaryContainer: Colors.white,
        primary: ZColors.bpLightBlack,
      ),
    );
  }

  static lightTheme() {
    return ThemeData.light().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Colors.white,
      indicatorColor: const Color(0xFFCBDCF8),
      hintColor: const Color(0xff133762),
      highlightColor: const Color(0xff133762),
      hoverColor: const Color.fromARGB(70, 47, 139, 232),
      focusColor: const Color(0xff133762),
      disabledColor: Colors.grey,
      cardColor: Colors.white,
      canvasColor: Colors.grey[50],
      brightness: Brightness.light,
      buttonTheme: const ButtonThemeData(colorScheme: ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        backgroundColor: ZColors.bc,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: ZColors.primaryColor,
        selectionColor: ZColors.primaryColor,
        selectionHandleColor: ZColors.primaryColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: ZColors.inputBorderColor,
              width: 5,
              style: BorderStyle.solid),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ZColors.inputBorderColorFocused,
            width: 5,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ZColors.inputBorderColorError,
            width: 5,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ZColors.inputBorderColorError,
            width: 1,
          ),
        ),
      ),
      colorScheme:
          ColorScheme.fromSwatch(primarySwatch: ZColors.primarySwatch).copyWith(
        background: ZColors.bc,
        primaryContainer: const Color(0xff3a3a3a),
        primary: ZColors.bpLightWhite,
      ),
    );
  }
}
