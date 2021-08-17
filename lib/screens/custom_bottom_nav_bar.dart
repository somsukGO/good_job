import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/screens/home_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<Widget> _buildScreens = [
    HomeScreen(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("ຫນ້າຫລັກ"),
        activeColorPrimary: ColorSources.dynamicPrimary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens,
      items: _navBarsItems(context),
      confineInSafeArea: true,
      backgroundColor: ColorSources.backgroundColor(context),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: ColorSources.backgroundColor(context),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 250),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 250),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
