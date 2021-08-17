import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';

class TextStyles {
  static titleTextBlack({BuildContext context, double fontSize = 20, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
      color: ColorSources.black(context),
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static titleTextWhite({BuildContext context, double fontSize = 20, fontWeight = FontWeight.w500}) {
    return TextStyle(
      color: ColorSources.white(context),
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static bodyTextBlack({
    BuildContext context,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    String fontStyle = 'Montserrat',
  }) {
    return TextStyle(
      color: ColorSources.black(context),
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontStyle,
    );
  }

  static bodyTextWhite({BuildContext context, double fontSize = 16, FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(color: ColorSources.white(context), fontWeight: fontWeight, fontSize: fontSize);
  }

  static staticBodyTextWhite({
    BuildContext context,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    String fontStyle = 'Montserrat',
  }) {
    return TextStyle(
      color: ColorSources.WHITE,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontStyle,
    );
  }

  static detailText({FontWeight fontWeight = FontWeight.w500, FontStyle fontStyle = FontStyle.normal, double fontSize = 16}) {
    return TextStyle(
      color: Get.isDarkMode ? ColorSources.BLACK : Color(0xffdee1e3),
      fontWeight: fontWeight,
      fontSize: fontSize,
      height: 1.5,
      fontStyle: fontStyle,
    );
  }
}
