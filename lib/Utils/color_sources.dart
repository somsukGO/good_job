import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorSources {
  static Color primary(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).backgroundColor;
  }

  static Color dividerColor(BuildContext context) {
    return Get.isDarkMode ? BLUE_GREY : Colors.grey[300];
  }

  static Color black(BuildContext context) {
    return Get.isDarkMode ? BLACK : WHITE;
  }

  static Color lightBlack(BuildContext context) {
    return Get.isDarkMode ? WHITE : BLACK_45;
  }

  static Color white(BuildContext context) {
    return Get.isDarkMode ? WHITE : BLACK;
  }

  static const WHITE_GREY_1 = Color(0xffc1c5c9);
  static const WHITE_GREY_2 = Color(0xffcbcfd4);
  static const BLUE_GREY = Color(0xFF304457);
  static const DARK_BLUE = Color(0xff283847);
  static const GREEN = Color(0xff00c9a7);
  static Color dynamicPrimary = Colors.cyan;
  static Color dynamicSecondary = Colors.cyanAccent;
  static const SECONDARY = Colors.cyanAccent;
  static const WHITE = Colors.white;
  static const BLACK = Color(0xff566265);
  static const BLACK_26 = Colors.black26;
  static const BLACK_45 = Colors.black45;
  static const BLACK_54 = Colors.black54;
  static const RED = Color(0xFFff3366);
}

// Color(0xFF15c2b1)
