import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/component/custom_drawer.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/setting_controller.dart';
import 'package:good_job/controllers/themeController.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/screens/auth_screen/login_screen.dart';
import 'package:good_job/widgets/page_button.dart';

import '../main.dart';

class SettingScreen extends StatefulWidget {
  static final String routeName = '/settings-screen';

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _themeController = Get.find<ThemeController>();
  final _settingController = Get.find<SettingController>();

  final _userController = Get.find<UserController>();
  final _jobController = Get.find<JobController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSources.dynamicPrimary,
        title: Text(
          'settings'.tr,
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
      drawer: Drawer(
        child: CustomDrawer(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.SIZE_DEFAULT),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorSources.dynamicPrimary.withOpacity(.20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        MyApp.themeNotifier.value == ThemeMode.light ? Icons.light_mode : Icons.dark_mode,
                        color: ColorSources.dynamicPrimary,
                      ),
                    ),
                    addHorizontalSpace(Dimensions.SIZE_LARGE),
                    Text(
                      'darkTheme'.tr,
                      style: TextStyle(
                        color: ColorSources.black(context),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _themeController.isDarkMode.value,
                  onChanged: (value) {
                    setState(() {
                      _themeController.toggleTheme();
                    });
                  },
                  activeTrackColor: Colors.grey[300],
                  activeColor: ColorSources.dynamicPrimary,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            addVerticalSpace(Dimensions.SIZE_DEFAULT),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorSources.dynamicPrimary.withOpacity(.20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        CupertinoIcons.bubble_left_bubble_right,
                        color: ColorSources.dynamicPrimary,
                      ),
                    ),
                    addHorizontalSpace(Dimensions.SIZE_LARGE),
                    Text(
                      'language'.tr,
                      style: TextStyle(
                        color: ColorSources.black(context),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _settingController.changeLanguage = 'lo';
                      },
                      child: Text(
                        'lao'.tr,
                        style: TextStyle(
                          color: ColorSources.dynamicPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: _settingController.selectedLanguage.value == 'lo'
                            ? ColorSources.dynamicPrimary.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                    ),
                    addHorizontalSpace(Dimensions.SIZE_EXTRA_SMALL),
                    TextButton(
                      onPressed: () {
                        _settingController.changeLanguage = 'en';
                      },
                      child: Text(
                        'english'.tr,
                        style: TextStyle(
                          color: ColorSources.dynamicPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: _settingController.selectedLanguage.value == 'en'
                            ? ColorSources.dynamicPrimary.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // addVerticalSpace(Dimensions.SIZE_DEFAULT),
            // PageButton(
            //   icon: CupertinoIcons.text_bubble,
            //   title: 'FAQ',
            //   color: ColorSources.dynamicPrimary,
            //   onTap: () {},
            // ),
            addVerticalSpace(Dimensions.SIZE_DEFAULT),
            PageButton(
              onTap: () {
                Get.defaultDialog(
                  title: 'confirm'.tr,
                  titleStyle: TextStyles.titleTextBlack(context: context),
                  backgroundColor: ColorSources.backgroundColor(context),
                  radius: 10,
                  content: Column(
                    children: [
                      Text(
                        'areYouSureYouWantToLogout'.tr,
                        style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                _jobController.applyingJobs.clear();
                                _jobController.jobs.clear();
                                _jobController.jobsTemp.clear();
                                _jobController.isJobsLoading.value = true;
                                _jobController.isJobsApplyingLoading.value = true;
                                _userController.logout();
                                _jobController.resetVar();
                                Get.offAllNamed(LoginScreen.routeName);
                              },
                              child: Text('ok'.tr)),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'cancel'.tr,
                              style: TextStyles.bodyTextBlack(
                                context: context,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              icon: CupertinoIcons.arrowshape_turn_up_right,
              title: 'logout'.tr,
              color: ColorSources.dynamicPrimary,
            ),
          ],
        ),
      ),
      backgroundColor: ColorSources.backgroundColor(context),
    );
  }
}
