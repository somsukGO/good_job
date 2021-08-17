import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/app_constants.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/image_sources.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/models/applying_job.dart';

class ApplyingDetailScreen extends StatefulWidget {
  static final String routeName = '/applying-detail-screen';

  @override
  _ApplyingDetailScreenState createState() => _ApplyingDetailScreenState();
}

class _ApplyingDetailScreenState extends State<ApplyingDetailScreen> {
  final _applyingJob = Get.arguments as ApplyingJob;

  bool isJobDetail = true;

  final desC = TextEditingController();

  @override
  void dispose() {
    desC.dispose();
    super.dispose();
  }

  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSources.dynamicPrimary,
        title: Text(
          _applyingJob.companyName,
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
                  height: 150,
                  child: Column(
                    children: [
                      addVerticalSpace(Dimensions.SIZE_EXTRA_SMALL),
                      ClipRRect(
                        child: _applyingJob.companyImage == "" || _applyingJob.companyImage == null
                            ? Image.asset(
                          ImageSources.GOOD_JOB,
                          width: 75,
                          height: 75,
                          fit: BoxFit.fill,
                        )
                            : Image.network(
                          '$IMAGE_URL${_applyingJob.companyImage}',
                          width: 75,
                          height: 75,
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      addVerticalSpace(Dimensions.SIZE_DEFAULT),
                      Text(
                        '${_applyingJob.jobName}',
                        style: TextStyle(
                          color: ColorSources.WHITE,
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ),
                      ),
                      addVerticalSpace(Dimensions.SIZE_EXTRA_SMALL),
                      Text(
                        _applyingJob.companyAddress,
                        style: TextStyle(
                          color: ColorSources.WHITE,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
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
                  child: Row(
                    children: [
                      Text(
                        'applyingDetail'.tr,
                        style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(Dimensions.SIZE_EXTRA_SMALL),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        SelectableText(_applyingJob.jobDescription, style: TextStyles.detailText()),
                        addVerticalSpace(Dimensions.SIZE_SMALL),
                        CustomDescription(description: _applyingJob.applyDescription),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        Card(
                          color: ColorSources.backgroundColor(context),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                RowText(title: 'degree'.tr, text: _applyingJob.degree),
                                addVerticalSpace(Dimensions.SIZE_SMALL),
                                RowText(title: 'major'.tr, text: _applyingJob.major),
                                addVerticalSpace(Dimensions.SIZE_SMALL),
                                RowText(
                                    title: 'applyDate'.tr,
                                    text:
                                        "${_applyingJob.applyDate.substring(0, 11)} -  ${_applyingJob.applyDate.substring(11, 16)}"),
                                if (_applyingJob.status == 'acepted')
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      addVerticalSpace(Dimensions.SIZE_SMALL),
                                      RowText(
                                          title: 'acceptedDate'.tr,
                                          text:
                                              "${_applyingJob.acceptDate.substring(0, 11)} - ${_applyingJob.applyDate.substring(11, 16)}"),
                                      addVerticalSpace(Dimensions.SIZE_SMALL),
                                      RowText(
                                          title: 'interviewDate'.tr,
                                          text:
                                              "${_applyingJob.interviewDate.substring(0, 11)} - ${_applyingJob.interviewDate.substring(11, 16)}"),
                                      addVerticalSpace(Dimensions.SIZE_SMALL),
                                      CustomDescription(description: _applyingJob.acceptDescription),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                addVerticalSpace(Dimensions.SIZE_DEFAULT),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: ColorSources.backgroundColor(context),
    );
  }
}

class RowText extends StatelessWidget {
  final String title;
  final String text;

  RowText({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title: ", style: TextStyles.detailText()),
        Text(
          "$text",
          style: TextStyles.detailText(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class CustomDescription extends StatelessWidget {
  final String description;

  CustomDescription({this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Dimensions.SIZE_DEFAULT),
      child: Container(
        padding: EdgeInsets.only(left: Dimensions.SIZE_DEFAULT),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: ColorSources.dynamicPrimary, width: 3)),
        ),
        child: SelectableText(description, style: TextStyles.detailText(fontStyle: FontStyle.italic)),
      ),
    );
  }
}
