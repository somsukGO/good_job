import 'package:flutter/material.dart';
import 'package:good_job/Utils/app_constants.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/image_sources.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/component/custom_drawer.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/models/apply.dart';
import 'package:good_job/screens/applying_detail_screen.dart';
import 'package:good_job/widgets/my_shimmer.dart';
import 'package:good_job/widgets/touch_able.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ApplyingScreen extends StatefulWidget {
  static const String routeName = '/applying-screen';

  @override
  _ApplyingScreenState createState() => _ApplyingScreenState();
}

class _ApplyingScreenState extends State<ApplyingScreen> {
  final _jobController = Get.find<JobController>();

  final _userController = Get.find<UserController>();

  void checkApplyingJob() {
    _jobController.applyingJobs.forEach((element) {
      if (element.status == 'acepted') _jobController.isAcceptedExists.value = true;
    });
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    checkApplyingJob();

    _jobController.findAllApplyingJob(Apply(memberId: int.parse(_userController.user.value.id)));

    final size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorSources.dynamicPrimary,
          title: Text(
            'applying'.tr,
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
        drawer: CustomDrawer(),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TouchAble(
                  function: () {
                    _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    _jobController.isPendingTab.value = false;
                  },
                  widget: Container(
                    alignment: Alignment.center,
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.5,
                          color: ColorSources.dynamicPrimary,
                        ),
                      ),
                    ),
                    child: Text('pending'.tr, style: TextStyles.bodyTextBlack(context: context)),
                    padding: EdgeInsets.symmetric(vertical: Dimensions.SIZE_SMALL),
                  ),
                ),
                TouchAble(
                  function: () {
                    _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    _jobController.isPendingTab.value = true;
                  },
                  widget: Container(
                    alignment: Alignment.center,
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.5,
                          color: ColorSources.GREEN,
                        ),
                      ),
                    ),
                    child: Text('accepted'.tr, style: TextStyles.bodyTextBlack(context: context)),
                    padding: EdgeInsets.symmetric(vertical: Dimensions.SIZE_SMALL),
                  ),
                ),
              ],
            ),
            addVerticalSpace(Dimensions.SIZE_DEFAULT),
            Expanded(
              child: PageView(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                children: [
                  Obx(
                    () => _jobController.isJobsApplyingLoading.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                            child: MyShimmer(),
                          )
                        : ApplyingJobList(status: 'apply'),
                  ),
                  Obx(
                    () => _jobController.isJobsApplyingLoading.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                            child: MyShimmer(),
                          )
                        : _jobController.applyingJobs.isEmpty
                            ? SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: EmptyImage(),
                              )
                            : _jobController.isAcceptedExists.value
                                ? ApplyingJobList(status: 'acepted')
                                : SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: EmptyImage(),
                                  ),
                  ),
                ],
                onPageChanged: (index) {
                  setState(() {
                    if (index == 0)
                      _jobController.isPendingTab.value = true;
                    else
                      _jobController.isPendingTab.value = false;
                  });
                },
              ),
            ),
          ],
        ),
        backgroundColor: ColorSources.backgroundColor(context),
      ),
    );
  }
}

class ApplyingJobList extends StatefulWidget {
  final String status;

  ApplyingJobList({this.status});

  @override
  _ApplyingJobListState createState() => _ApplyingJobListState();
}

class _ApplyingJobListState extends State<ApplyingJobList> {
  final _jobController = Get.find<JobController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _userController = Get.find<UserController>();

    RefreshController _refreshController = RefreshController(initialRefresh: false);

    void _onRefresh() async {
      _jobController.isJobsApplyingLoading.value = true;
      _jobController.findAllApplyingJob(Apply(memberId: int.parse(_userController.user.value.id)));
      await Future.delayed(Duration(milliseconds: 500));
      _refreshController.refreshCompleted();
    }

    return Obx(
      () => SmartRefresher(
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: _jobController.applyingJobs.isEmpty
            ? SingleChildScrollView(
                child: EmptyImage(),
              )
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GetBuilder<JobController>(
                    id: 'applyingJobs',
                    builder: (controller) {
                      if (_jobController.applyingJobs[index].status != widget.status) return SizedBox.shrink();
                      return Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                            color: Get.isDarkMode ? ColorSources.WHITE : Color(0xff283847),
                            child: TouchAble(
                              radius: 4,
                              function: () {
                                Get.toNamed(ApplyingDetailScreen.routeName, arguments: _jobController.applyingJobs[index]);
                              },
                              widget: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.SIZE_SMALL,
                                  horizontal: Dimensions.SIZE_DEFAULT,
                                ),
                                height: 85,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      child: controller.applyingJobs[index].companyImage == "" ||
                                              controller.applyingJobs[index].companyImage == null
                                          ? Image.asset(
                                              ImageSources.GOOD_JOB,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.network(
                                              '$IMAGE_URL/${controller.applyingJobs[index].companyImage}',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.fill,
                                            ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            '${controller.applyingJobs[index].companyName}, ${controller.applyingJobs[index].companyAddress}',
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: Get.isDarkMode ? ColorSources.BLACK_45 : ColorSources.WHITE_GREY_1,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          width: size.width - (40 + Dimensions.SIZE_DEFAULT * 5),
                                        ),
                                        Container(
                                          child: Text(
                                            '${controller.applyingJobs[index].jobName}',
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: ColorSources.black(context),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                              letterSpacing: 0.5,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          width: size.width - (40 + Dimensions.SIZE_DEFAULT * 5),
                                        ),
                                        Container(
                                          child: Text(
                                            '${controller.applyingJobs[index].applyDate}',
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                              color: Get.isDarkMode ? ColorSources.BLACK_54 : ColorSources.WHITE_GREY_2,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          width: size.width - (40 + Dimensions.SIZE_DEFAULT * 5),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        ],
                      );
                    },
                  );
                },
                itemCount: _jobController.applyingJobs.length,
              ),
      ),
    );
  }
}

class EmptyImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addVerticalSpace(50),
        Image.asset(
          ImageSources.EMPTY,
          height: 150,
          width: 200,
          fit: BoxFit.fill,
        ),
      ],
    );
  }
}
