import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/app_constants.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/image_sources.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:good_job/Utils/utils.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/models/apply.dart';
import 'package:good_job/models/jobs.dart';
import 'package:good_job/screens/send_apply_screen.dart';
import 'package:good_job/widgets/container_text.dart';
import 'package:good_job/widgets/custom_title.dart';
import 'package:good_job/widgets/loading.dart';
import 'package:good_job/widgets/touch_able.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class JobDetailScreen extends StatefulWidget {
  static final String routeName = '/job-detail-screen';

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final _job = Get.arguments as Jobs;
  final _userController = Get.find<UserController>();
  final _jobController = Get.find<JobController>();

  bool isJobDetail = true;
  final PageController _pageController = PageController();

  final desC = TextEditingController();

  @override
  void dispose() {
    desC.dispose();
    super.dispose();
  }

  bool isSending = false;

  // download file
  int progress = 0;

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    _jobController.isCompanyLoading.value = true;

    _jobController.loadCompany(_job.companyId);

    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSources.dynamicPrimary,
        title: Text(
          _job.companyName,
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
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                  color: ColorSources.dynamicPrimary,
                  width: double.infinity,
                  height: 200,
                  child: Column(
                    children: [
                      addVerticalSpace(Dimensions.SIZE_EXTRA_SMALL),
                      ClipRRect(
                        child: _job.image == "" || _job.image == null
                            ? Image.asset(
                                ImageSources.GOOD_JOB,
                                width: 75,
                                height: 75,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                '$IMAGE_URL/${_job.image}',
                                width: 75,
                                height: 75,
                                fit: BoxFit.fill,
                              ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      addVerticalSpace(Dimensions.SIZE_DEFAULT),
                      Text(
                        '${_job.jobDetail.jobName}',
                        style: TextStyle(
                          color: ColorSources.WHITE,
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ),
                      ),
                      addVerticalSpace(Dimensions.SIZE_EXTRA_SMALL),
                      Text(
                        _job.address,
                        style: TextStyle(
                          color: ColorSources.WHITE,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      addVerticalSpace(Dimensions.SIZE_LARGE),
                      Text(
                        '${_job.jobDetail.salaryRate}',
                        style: TextStyle(
                          color: ColorSources.WHITE,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 25,
                  decoration: BoxDecoration(
                    color: ColorSources.dynamicPrimary,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                ),
                addVerticalSpace(Dimensions.SIZE_DEFAULT),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                  child: Column(
                    children: [
                      Container(
                        width: size.width - Dimensions.SIZE_DEFAULT * 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TouchAble(
                              function: () {
                                setState(() {
                                  isJobDetail = true;
                                  _pageController.animateToPage(0,
                                      duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                });
                              },
                              radius: 5,
                              widget: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.SIZE_EXTRA_SMALL,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1.5,
                                      color: isJobDetail ? ColorSources.dynamicPrimary : Colors.transparent,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'jobDetail'.tr,
                                  style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ),
                            ),
                            addHorizontalSpace(Dimensions.SIZE_LARGE),
                            TouchAble(
                              function: () {
                                setState(() {
                                  isJobDetail = false;
                                  _pageController.animateToPage(1,
                                      duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                });
                              },
                              radius: 5,
                              widget: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.SIZE_EXTRA_SMALL,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1.5,
                                      color: isJobDetail ? Colors.transparent : ColorSources.dynamicPrimary,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'company'.tr,
                                  style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(Dimensions.SIZE_DEFAULT),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            SelectableText(
                              _job.jobDetail.description,
                              style: TextStyles.detailText(),
                            ),
                            Text(
                              "${'hire'.tr}: ${_job.jobDetail.position}",
                              style: TextStyles.detailText(fontStyle: FontStyle.italic),
                            ),
                            Text(
                              "${'postDate'.tr}: ${_job.jobDetail.date.substring(0, 11)} -  ${_job.jobDetail.date.substring(11, 16)}",
                              style: TextStyles.detailText(fontStyle: FontStyle.italic),
                            ),
                            addVerticalSpace(Dimensions.SIZE_SMALL),
                            Card(
                              color: ColorSources.backgroundColor(context),
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTitle(title: 'requirement'.tr),
                                    addVerticalSpace(Dimensions.SIZE_SMALL),
                                    Padding(
                                      padding: const EdgeInsets.only(left: Dimensions.SIZE_DEFAULT),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '- ${_job.jobDetail.degree}',
                                            style: TextStyles.detailText(),
                                          ),
                                          Text(
                                            '- ${_job.jobDetail.major}',
                                            style: TextStyles.detailText(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            Obx(
                              () => _jobController.isCompanyLoading.value
                                  ? Padding(
                                      child: SpinKitFadingCircle(
                                        color: ColorSources.dynamicPrimary,
                                        size: 45.0,
                                      ),
                                      padding: EdgeInsets.only(top: Dimensions.SIZE_EXTRA_LARGE),
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TitleText(
                                          title: 'name'.tr,
                                          text: '${_jobController.company.companyName}',
                                        ),
                                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                                        TitleText(
                                          title: 'phoneNumber'.tr,
                                          text: '${_jobController.company.companyPhonenumber}',
                                        ),
                                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                                        TitleText(
                                          title: 'coordinatorPhoneNumber'.tr,
                                          text: '${_jobController.company.coordinatorPhonenumber}',
                                        ),
                                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                                        TitleText(
                                          title: 'contactInfo'.tr,
                                          text: '${_jobController.company.companyContactInfo}',
                                        ),
                                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                                        TitleText(
                                          title: 'email'.tr,
                                          text: '${_jobController.company.companyEmail}',
                                        ),
                                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                                        TitleText(
                                          title: 'province'.tr,
                                          text: '${_jobController.company.province}',
                                        ),
                                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                                        TitleText(
                                          title: 'district'.tr,
                                          text: '${_jobController.company.district}',
                                        ),
                                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                                        TitleText(
                                          title: 'address'.tr,
                                          text: '${_jobController.company.address}',
                                        ),
                                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                                        TitleText(
                                          title: 'detail'.tr,
                                          text: '${_job.description}',
                                        ),
                                        addVerticalSpace(60),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onPageChanged: (value) {
                      setState(() {
                        isJobDetail = value == 0 ? true : false;
                      });
                    },
                  ),
                ),
                addVerticalSpace(Dimensions.SIZE_DEFAULT),
              ],
            ),
            Positioned(
              bottom: 10,
              child: Container(
                color: ColorSources.backgroundColor(context),
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TouchAble(
                      function: () async {
                        if (_job.fileForm == "") {
                          Utils.errorDialog(context: context, title: 'thisJobDoesNotHaveFileForm'.tr);
                        } else {
                          final status = await Permission.storage.request();

                          if (status.isGranted) {
                            final externalDir = await getExternalStorageDirectory();

                            await FlutterDownloader.enqueue(
                              url: IMAGE_URL + _job.fileForm,
                              // url: _job.fileForm.substring(_job.fileForm.length - 4, _job.fileForm.length) == '.pdf'
                              //     ? IMAGE_URL + _job.fileForm
                              //     : DEMO_APPLYING_FORM,
                              savedDir: externalDir.path,
                              fileName: 'Applying form for ${_job.jobDetail.jobName} ${DateTime.now().millisecondsSinceEpoch}'
                                  '.toString()',
                              showNotification: true,
                              openFileFromNotification: true,
                            );
                          } else {
                            print("Permission deined");
                          }
                        }
                      },
                      widget: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorSources.dynamicPrimary, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'downloadForm'.tr,
                          style: TextStyles.bodyTextBlack(
                            context: context,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                    ElevatedButton(
                      onPressed: () async {
                        final apply = Apply(
                          memberId: int.parse(_userController.user.value.id),
                          degreeId: int.parse(_job.jobDetail.degreeId),
                          majorId: int.parse(_job.jobDetail.majorId),
                          postJobDetailId: int.parse(_job.jobDetail.id),
                        );
                        Get.toNamed(SendApplyScreen.routeName, arguments: apply);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Text(
                          'applyNow'.tr,
                          style: TextStyles.staticBodyTextWhite(
                            context: context,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: ColorSources.dynamicPrimary,
                        onPrimary: Colors.teal.shade100,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isSending) Loading(title: 'sending'.tr),
          ],
        ),
      ),
      backgroundColor: ColorSources.backgroundColor(context),
    );
  }
}
