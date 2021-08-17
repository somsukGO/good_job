import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/screens/auth_screen/login_screen.dart';

import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  static final String routeName = '/onboarding-screen';

  final Color indicatorColor;
  final Color selectedIndicatorColor;

  OnboardingScreen({
    this.indicatorColor = Colors.grey,
    this.selectedIndicatorColor = Colors.black,
  });

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final onboardingController = Get.put(OnboardingController());
    onboardingController.initBoardingList();

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: onboardingController.onBoardingList.length,
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(Dimensions.SIZE_DEFAULT),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Image.asset(
                              onboardingController.onBoardingList[index].imageUrl,
                              width: 300,
                              height: 300,
                            ),
                          ),
                          Text(
                            onboardingController.onBoardingList[index].title,
                            style: TextStyles.titleTextBlack(context: context, fontWeight: FontWeight.w700),
                          ),
                          addVerticalSpace(Dimensions.SIZE_SMALL),
                          Text(
                            onboardingController.onBoardingList[index].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorSources.black(context),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    onboardingController.changeSelectIndex(index);
                  },
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.SIZE_SMALL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _pageIndicators(onboardingController),
                      ),
                    ),
                    Container(
                      height: 45,
                      margin: EdgeInsets.symmetric(horizontal: 70),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [ColorSources.dynamicPrimary, ColorSources.dynamicSecondary],
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (onboardingController.selectedIndex.value == onboardingController.onBoardingList.length - 1) {
                            onboardingController.selectedIndex.value = 0;
                            Get.offAllNamed(LoginScreen.routeName);
                          } else {
                            _pageController.animateToPage(onboardingController.selectedIndex.value + 1,
                                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Obx(
                            () => Text(
                              onboardingController.selectedIndex.value == onboardingController.onBoardingList.length - 1
                                  ? 'GET STARTED'
                                  : 'NEXT',
                              style: TextStyle(
                                color: ColorSources.WHITE,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: ColorSources.backgroundColor(context),
    );
  }

  List<Widget> _pageIndicators(OnboardingController onboardingController) {
    List<Obx> _indicators = [];

    for (int i = 0; i < onboardingController.onBoardingList.length; i++) {
      _indicators.add(
        Obx(
          () => Container(
            width: i == onboardingController.selectedIndex.value ? 18 : 7,
            height: 7,
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: i == onboardingController.selectedIndex.value ? ColorSources.dynamicPrimary : ColorSources.WHITE,
              borderRadius: i == onboardingController.selectedIndex.value ? BorderRadius.circular(50) : BorderRadius.circular(25),
            ),
          ),
        ),
      );
    }
    return _indicators;
  }
}
