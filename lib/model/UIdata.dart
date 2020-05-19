import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class UIData {
  //routes
  static const String homeRoute = "/home";
  static const String profileOneRoute = "/View Profile";

  //strings
  static const String appName = "CLIFFLY";

  static const String firstitem = "Country Park";
  static const String seconditem = "Explore";
  static const String author = "Carl Chan";
  static const String setting = "More";
  static const String lastupdate = "19/05/2020";
  static const String version = "v0.0.2a";

  //fonts
  static const String quickFont = "Quicksand";
  static const String ralewayFont = "Raleway";
  static const String quickBoldFont = "Quicksand_Bold.otf";
  static const String quickNormalFont = "Quicksand_Book.otf";
  static const String quickLightFont = "Quicksand_Light.otf";

  //gneric
  static const String error = "Error";
  static const String na = "N/A";
  static const String success = "Success";
  static const String ok = "OK";
  static const String forgot_password = "Forgot Password?";
  static const String something_went_wrong = "Something went wrong";
  static const String coming_soon = "Coming Soon";

  static const MaterialColor ui_kit_color = Colors.grey;

//colors
  static List<Color> kitGradients = [
    Colors.blueGrey.shade800,
    Colors.black87,
  ];
  static List<Color> kitGradients2 = [
    Colors.cyan.shade600,
    Colors.blue.shade900
  ];

  static const Color themeColor = Color(0xff505050);
  //randomcolor
  static final Random _random = new Random();

  static final Shader gradientText = LinearGradient(
    colors: <Color>[Color(0xff283c86), Color(0xff45a247)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}
