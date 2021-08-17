import 'package:good_job/Utils/image_sources.dart';

import 'onboarding_model.dart';

final String crateJob = 'No career site? Post jobs directly on Good Job. Post for free and appear in general search results';

final String findJob = 'Finding the right talent can be a challenge. Reach qualified candidates where spending time on Good Job';

final String applying =
    'Get free jobs, know about relevant job vacancies and ease your job search. Apply for jobs across top companies';

class OnboardingRepo {
  List<OnboardingModel> getOnBoardingList() {
    List<OnboardingModel> onboarding = [
      OnboardingModel(ImageSources.ONBOARDING_ONE, 'CREATE JOB', crateJob),
      OnboardingModel(ImageSources.ONBOARDING_TWO, 'FIND JOB', findJob),
      OnboardingModel(ImageSources.ONBOARDING_THREE, 'APPLYING', applying),
    ];
    return onboarding;
  }
}
