import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/app_constants.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/image_sources.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:good_job/Utils/utils.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/component/custom_drawer.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/screens/job_detail_screen.dart';
import 'package:good_job/widgets/end_drawer_filter_dynamic.dart';
import 'package:good_job/widgets/my_shimmer.dart';
import 'package:good_job/widgets/search_field.dart';
import 'package:good_job/widgets/touch_able.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _jobController = Get.find<JobController>();
  final _userController = Get.find<UserController>();

  bool isJobLoaded = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_userController.fromLogin.value) {
        await _userController.getMember();

        var firstName = _userController.user.value.memberName == null ? 'Guest' : _userController.user.value.memberName;
        var lastName = _userController.user.value.memberLastname == null ? '' : _userController.user.value.memberLastname;

        Utils.snackbar(context: context, title: 'loginSuccess'.tr, message: "${'welcomeBack'.tr} $firstName $lastName");
        _userController.fromLogin.value = false;
        _userController.fromLogout.value = true;
      }
    });

    final size = MediaQuery.of(context).size;

    if (!isJobLoaded) {
      _jobController.findAllJob();
      isJobLoaded = true;
      _jobController.loadMajor();
      _jobController.loadSalary();
      _jobController.loadDegree();
      _jobController.loadProvince();
      _jobController.loadDistrict();
      _jobController.loadPosition();
    }

    RefreshController _refreshController = RefreshController(initialRefresh: false);

    void _onRefresh() async {
      _jobController.isJobsLoading.value = true;
      _jobController.randomIndex.clear();
      _jobController.findAllJob();
      await Future.delayed(Duration(milliseconds: 500));
      _refreshController.refreshCompleted();
      _jobController.loadMajor();
      _jobController.loadSalary();
      _jobController.loadProvince();
      _jobController.loadDegree();
      _jobController.loadDistrict();
      _jobController.loadPosition();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSources.dynamicPrimary,
        title: Text(
          'goodJob'.tr,
          style: TextStyle(
            color: ColorSources.WHITE,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark,
        actions: [
          Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
              icon: Icon(Icons.wysiwyg_sharp),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: EndDrawerFilterDynamic(),
      ),
      drawer: CustomDrawer(),
      body: Obx(
        () => _jobController.isJobsLoading.value
            ? JobsLoadingShimmer()
            : Obx(
                () => _jobController.jobs.isEmpty
                    ? SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              child: Intro(),
                              height: 151,
                            ),
                            addVerticalSpace(50),
                            Image.asset(
                              ImageSources.EMPTY,
                              height: 150,
                              width: 200,
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      )
                    : SmartRefresher(
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: _jobController.jobs.length,
                          itemBuilder: (context, index) {
                            return GetBuilder<JobController>(
                              id: 'jobs',
                              builder: (controller) {
                                return Column(
                                  children: [
                                    if (index == 0)
                                      Column(
                                        children: [
                                          Intro(),
                                          addVerticalSpace(Dimensions.SIZE_DEFAULT),
                                          LandingJobs(),
                                          addVerticalSpace(Dimensions.SIZE_SMALL),
                                        ],
                                      ),
                                    Card(
                                      elevation: 0.3,
                                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                                      color: Get.isDarkMode ? ColorSources.WHITE : Color(0xff283847),
                                      child: TouchAble(
                                        radius: 4,
                                        function: () {
                                          Get.toNamed(JobDetailScreen.routeName, arguments: _jobController.jobs[index]);
                                        },
                                        widget: Container(
                                          padding: const EdgeInsets.all(Dimensions.SIZE_SMALL),
                                          height: 85,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                child: controller.jobs[index].image == "" || controller.jobs[index].image == null
                                                    ? Image.asset(
                                                        ImageSources.GOOD_JOB,
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.network(
                                                        '$IMAGE_URL/${controller.jobs[index].image}',
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
                                                      '${controller.jobs[index].companyName}, ${controller.jobs[index].address}',
                                                      overflow: TextOverflow.fade,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                        color: Get.isDarkMode ? ColorSources.BLACK_45 : ColorSources.WHITE_GREY_1,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 12,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                    width: size.width - (61 + Dimensions.SIZE_DEFAULT * 5),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      '${controller.jobs[index].jobDetail.jobName}',
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
                                                    width: size.width - (61 + Dimensions.SIZE_DEFAULT * 5),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      '${controller.jobs[index].jobDetail.salaryRate}',
                                                      overflow: TextOverflow.fade,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                        color: Get.isDarkMode ? ColorSources.BLACK_54 : ColorSources.WHITE_GREY_2,
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: 15,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                    width: size.width - (61 + Dimensions.SIZE_DEFAULT * 5),
                                                  ),
                                                ],
                                              ),
                                              Flexible(
                                                child: Text(
                                                  "${Utils.daysBetween(controller.jobs[index].jobDetail.date)} ${'days'.tr}",
                                                  style: TextStyles.bodyTextBlack(context: context, fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    addVerticalSpace(Dimensions.SIZE_SMALL),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
      ),
      backgroundColor: Get.isDarkMode ? Colors.grey[50] : Color(0xFF192734),
    );
  }
}

class JobsLoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Intro(),
          height: 151,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.SIZE_DEFAULT),
            child: MyShimmer(),
          ),
        ),
      ],
    );
  }
}

class LandingJobs extends StatefulWidget {
  @override
  _LandingJobsState createState() => _LandingJobsState();
}

class _LandingJobsState extends State<LandingJobs> {
  final colorList = [
    [Colors.white, Colors.white],
    [Colors.cyan.shade400, Colors.cyan.shade500],
    [Colors.teal, Colors.tealAccent],
    [Colors.purple, Colors.purpleAccent],
    [Colors.green, Colors.greenAccent],
    [Colors.pink, Colors.pinkAccent],
    [Colors.lime, Colors.limeAccent],
    [Color(0xff283847), Color(0xff283847)],
  ];

  final _jobController = Get.find<JobController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Container(
            width: size.width - Dimensions.SIZE_DEFAULT * 2,
            child: Text(
              'recommended'.tr,
              style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
        addVerticalSpace(Dimensions.SIZE_SMALL),
        Container(
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final companyNameTextStyle = index == 0
                  ? TextStyles.staticBodyTextWhite(
                      context: context,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: 'Roboto',
                    )
                  : TextStyles.bodyTextBlack(
                      context: context,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: 'Roboto',
                    );
              final positionTextStyle = index == 0
                  ? TextStyle(
                      color: ColorSources.WHITE,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      letterSpacing: 0.5,
                      fontFamily: 'Roboto',
                    )
                  : TextStyle(
                      color: ColorSources.black(context),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      letterSpacing: 0.5,
                      fontFamily: 'Roboto',
                    );
              final salaryTextStyle = index == 0
                  ? TextStyles.staticBodyTextWhite(
                      context: context,
                      fontWeight: FontWeight.w500,
                      fontStyle: 'Roboto',
                    )
                  : TextStyles.bodyTextBlack(
                      context: context,
                      fontWeight: FontWeight.w500,
                      fontStyle: 'Roboto',
                    );
              final addressTextStyle = index == 0
                  ? TextStyles.staticBodyTextWhite(
                      context: context,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: 'Roboto',
                    )
                  : TextStyles.bodyTextBlack(
                      context: context,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontStyle: 'Roboto',
                    );
              return Card(
                margin: EdgeInsets.only(
                  left: index == 0 ? Dimensions.SIZE_DEFAULT : 0,
                  right: Dimensions.SIZE_DEFAULT,
                  bottom: 5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: ColorSources.backgroundColor(context),
                elevation: 0.3,
                child: TouchAble(
                  radius: 15,
                  function: () {
                    Get.toNamed(JobDetailScreen.routeName, arguments: _jobController.jobs[index]);
                  },
                  widget: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: index == 0
                            ? colorList[1]
                            : Get.isDarkMode
                                ? colorList[0]
                                : colorList[7],
                      ),
                    ),
                    padding: const EdgeInsets.all(Dimensions.SIZE_DEFAULT),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              ClipRRect(
                                child: _jobController.jobs[_jobController.randomIndex[index]].image == "" ||
                                        _jobController.jobs[_jobController.randomIndex[index]].image == null
                                    ? Image.asset(
                                        ImageSources.GOOD_JOB,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        '$IMAGE_URL/${_jobController.jobs[_jobController.randomIndex[index]].image}',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.fill,
                                      ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              addHorizontalSpace(10),
                              Container(
                                width: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _jobController.jobs[_jobController.randomIndex[index]].companyName,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: companyNameTextStyle,
                                    ),
                                    addVerticalSpace(5),
                                    Text(
                                      _jobController.jobs[_jobController.randomIndex[index]].jobDetail.jobName,
                                      style: positionTextStyle,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          width: 220,
                        ),
                        addVerticalSpace(15),
                        Text(
                          _jobController.jobs[_jobController.randomIndex[index]].jobDetail.salaryRate,
                          style: salaryTextStyle,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        addVerticalSpace(5),
                        Text(
                          _jobController.jobs[_jobController.randomIndex[index]].address,
                          style: addressTextStyle,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: _jobController.jobs.length > 5 ? 5 : _jobController.jobs.length,
          ),
        ),
      ],
    );
  }
}

class Intro extends StatelessWidget {
  final _authC = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: Dimensions.SIZE_DEFAULT,
        right: Dimensions.SIZE_DEFAULT,
        bottom: Dimensions.SIZE_DEFAULT,
        top: Dimensions.SIZE_EXTRA_SMALL,
      ),
      decoration: BoxDecoration(
        color: ColorSources.dynamicPrimary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              "${'greeting'.tr}, ${_authC.user.value.memberName} ${_authC.user.value.memberLastname}",
              style: TextStyle(
                color: ColorSources.WHITE,
                fontWeight: FontWeight.w600,
                fontSize: 22,
                fontFamily: 'Montserrat',
              ),
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          addVerticalSpace(Dimensions.SIZE_EXTRA_SMALL),
          Text(
            'findYourDreamJob'.tr,
            style: TextStyle(
              color: ColorSources.WHITE,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          addVerticalSpace(Dimensions.SIZE_DEFAULT),
          SearchField(),
        ],
      ),
    );
  }
}
