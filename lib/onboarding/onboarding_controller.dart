import 'package:get/get.dart';

import 'onboarding_model.dart';
import 'onboarding_repo.dart';

class OnboardingController extends GetxController {
  OnboardingRepo onboardingRepo;

  OnboardingController() {
    this.onboardingRepo = new OnboardingRepo();
  }

  List<OnboardingModel> _onBoardingList = [];

  List<OnboardingModel> get onBoardingList => _onBoardingList;

  var selectedIndex = 0.obs;

  changeSelectIndex(int index) {
    selectedIndex.value = index;
  }

  void initBoardingList() async {
    _onBoardingList.clear();
    _onBoardingList.addAll(onboardingRepo.getOnBoardingList());
  }
}
