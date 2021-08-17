import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/text_styles.dart';

import 'dimensions.dart';

class Utils {
  static String localDateToString(String localDateString) {
    if (localDateString == null) return null;
    final dateSplit = localDateString.split('-');
    return dateSplit[2] + '-' + dateSplit[1] + '-' + dateSplit[0];
  }

  static String stringToLocalDate(String dateString) {
    if (dateString == null) return null;
    final dateSplit = dateString.split('-');
    return dateSplit[2] + '-' + dateSplit[1] + '-' + dateSplit[0];
  }

  static int daysBetween(String fromString) {
    DateTime from = DateTime.parse(fromString.substring(0, 10));
    DateTime to = DateTime.now();
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static Future<DateTime> selectDate({BuildContext context, DateTime lastDate}) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: lastDate ?? DateTime(2022),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Get.isDarkMode
              ? ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: ColorSources.dynamicPrimary,
                    onSurface: ColorSources.BLACK,
                  ),
                )
              : ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: ColorSources.dynamicPrimary,
                    onSurface: ColorSources.WHITE,
                  ),
                ),
          child: child,
        );
      },
    );
  }

  static Future<void> infoDialog({BuildContext context, String title, Color color = Colors.cyan, Function function}) {
    return Get.defaultDialog(
      titleStyle: TextStyles.titleTextBlack(context: context, fontSize: 17),
      backgroundColor: ColorSources.backgroundColor(context),
      radius: 10,
      title: title,
      middleTextStyle: TextStyles.bodyTextBlack(context: context),
      content: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: color),
        onPressed: () {
          Navigator.of(context).pop();
          function();
        },
        child: Text(
          'ok'.tr,
          style: TextStyles.staticBodyTextWhite(
            context: context,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  static Future<void> errorDialog({BuildContext context, String title, Color color = ColorSources.RED}) {
    return Get.defaultDialog(
      titleStyle: TextStyles.titleTextBlack(context: context, fontSize: 17),
      backgroundColor: ColorSources.backgroundColor(context),
      radius: 10,
      title: title,
      content: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: color),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'ok'.tr,
              style: TextStyles.staticBodyTextWhite(
                context: context,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> snackbar({BuildContext context, Color color, String title, String message}) async {
    final size = MediaQuery.of(context).size;

    if (!Get.isSnackbarOpen)
      return Get.snackbar(
        null,
        null,
        titleText: Text(
          title,
          style: TextStyle(
            color: ColorSources.WHITE,
            fontWeight: FontWeight.w500,
          ),
        ),
        messageText: Text(
          message,
          style: TextStyle(
            color: ColorSources.WHITE,
          ),
        ),
        snackPosition: SnackPosition.TOP,
        colorText: ColorSources.white(context),
        backgroundColor: color ?? Color(0xff00c9a7),
        borderRadius: 5,
        animationDuration: Duration(milliseconds: 900),
        duration: Duration(milliseconds: 2000),
        maxWidth: size.width - Dimensions.SIZE_DEFAULT * 2,
      );
  }
}
