import 'package:flutter/material.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:get/get.dart';

class AboutUsScreen extends StatelessWidget {
  static final String routeName = '/about-us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSources.dynamicPrimary,
        title: Text(
          'aboutUs'.tr,
          style: TextStyle(
            color: ColorSources.WHITE,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark,
      ),
      backgroundColor: ColorSources.backgroundColor(context),
    );
  }
}
