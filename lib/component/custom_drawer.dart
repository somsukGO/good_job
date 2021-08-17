import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/app_constants.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/image_sources.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/screens/applying_screen.dart';
import 'package:good_job/screens/home_screen.dart';
import 'package:good_job/screens/profile_screen.dart';
import 'package:good_job/screens/setting_screen.dart';
import 'package:good_job/widgets/page_button.dart';
import 'package:good_job/widgets/touch_able.dart';

class CustomDrawer extends StatelessWidget {
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: ColorSources.backgroundColor(context),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 230,
              color: ColorSources.dynamicPrimary,
              padding: EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  addVerticalSpace(Dimensions.SIZE_DEFAULT),
                  TouchAble(
                    function: () {
                      Navigator.of(context).pop();
                      Get.toNamed(ProfileScreen.routeName);
                    },
                    radius: 60,
                    widget: ClipRRect(
                      child: _userController.user.value.image == "" || _userController.user.value.image == null
                          ? Image.asset(
                              ImageSources.PROFILE_AVATAR,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : Obx(
                              () => Image.network(
                                '$IMAGE_URL/${_userController.user.value.image}',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  addVerticalSpace(Dimensions.SIZE_DEFAULT),
                  Obx(
                    () => Text(
                      '${_userController.user.value.memberName} ${_userController.user.value.memberLastname}',
                      style: TextStyle(
                        color: ColorSources.WHITE,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                  addVerticalSpace(Dimensions.SIZE_EXTRA_SMALL),
                  // Text(
                  //   'Full stack developer',
                  //   style: TextStyle(
                  //     color: ColorSources.WHITE,
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w500,
                  //     fontFamily: 'Montserrat',
                  //   ),
                  //   overflow: TextOverflow.fade,
                  //   softWrap: false,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.SIZE_DEFAULT),
              child: Column(
                children: [
                  PageButton(
                    icon: CupertinoIcons.home,
                    title: 'home'.tr,
                    color: ColorSources.dynamicPrimary,
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.offAllNamed(HomeScreen.routeName);
                    },
                  ),
                  addVerticalSpace(Dimensions.SIZE_DEFAULT),
                  PageButton(
                    icon: CupertinoIcons.person,
                    title: 'profile'.tr,
                    color: ColorSources.dynamicPrimary,
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(ProfileScreen.routeName);
                    },
                  ),
                  addVerticalSpace(Dimensions.SIZE_DEFAULT),
                  PageButton(
                    icon: Icons.assignment_turned_in_outlined,
                    title: 'applying'.tr,
                    color: ColorSources.dynamicPrimary,
                    onTap: () {
                      Get.toNamed(ApplyingScreen.routeName);
                    },
                  ),
                  addVerticalSpace(Dimensions.SIZE_DEFAULT),
                  PageButton(
                    icon: CupertinoIcons.settings,
                    title: 'settings'.tr,
                    color: ColorSources.dynamicPrimary,
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.toNamed(SettingScreen.routeName);
                    },
                  ),
                  addVerticalSpace(Dimensions.SIZE_DEFAULT),
                  // PageButton(
                  //   title: 'aboutUs'.tr,
                  //   icon: CupertinoIcons.info,
                  //   color: ColorSources.dynamicPrimary,
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //     Get.toNamed(AboutUsScreen.routeName);
                  //   },
                  // ),
                ],
              ),
            ),
          ],
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
