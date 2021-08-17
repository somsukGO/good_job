import 'package:flutter/material.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/widgets/touch_able.dart';

class EndDrawerFilterDynamic extends StatefulWidget {
  @override
  _EndDrawerFilterDynamicState createState() => _EndDrawerFilterDynamicState();
}

class _EndDrawerFilterDynamicState extends State<EndDrawerFilterDynamic> {
  final _jobController = Get.find<JobController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSources.backgroundColor(context),
      child: ListView(children: [
        Container(
          color: ColorSources.backgroundColor(context),
          padding: EdgeInsets.all(Dimensions.SIZE_DEFAULT),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'findByMajor'.tr,
                style: TextStyles.titleTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(_jobController.majors.length, (index) {
                  return TouchAble(
                    radius: 5,
                    function: () {
                      _jobController.isJobsLoading.value = true;
                      Get.back();
                      _jobController.searchJob(filter: 'm.major', value: _jobController.majors[index].major);
                    },
                    widget: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: Dimensions.SIZE_DEFAULT,
                        right: Dimensions.SIZE_DEFAULT,
                        top: Dimensions.SIZE_SMALL,
                        bottom: Dimensions.SIZE_SMALL,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
                        ),
                      ),
                      child: Text(
                        '${_jobController.majors[index].major}',
                        style: TextStyles.bodyTextBlack(context: context),
                      ),
                    ),
                  );
                }),
              ),
              addVerticalSpace(Dimensions.SIZE_DEFAULT),
              Text(
                'findByDegree'.tr,
                style: TextStyles.titleTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(_jobController.degrees.length, (index) {
                  return TouchAble(
                    radius: 5,
                    function: () {
                      _jobController.isJobsLoading.value = true;
                      Get.back();
                      _jobController.searchJob(filter: 'dg.degree', value: _jobController.degrees[index].degree);
                    },
                    widget: Container(
                      padding: EdgeInsets.only(
                        left: Dimensions.SIZE_DEFAULT,
                        right: Dimensions.SIZE_DEFAULT,
                        top: Dimensions.SIZE_SMALL,
                        bottom: Dimensions.SIZE_SMALL,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
                        ),
                      ),
                      child: Text(
                        '${_jobController.degrees[index].degree}',
                        style: TextStyles.bodyTextBlack(context: context),
                      ),
                    ),
                  );
                }),
              ),
              addVerticalSpace(Dimensions.SIZE_DEFAULT),
              Text(
                'findBySalary'.tr,
                style: TextStyles.titleTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(_jobController.salaries.length, (index) {
                  return TouchAble(
                    radius: 5,
                    function: () {
                      _jobController.isJobsLoading.value = true;
                      Get.back();
                      _jobController.searchJob(filter: 's.salaryRate', value: _jobController.salaries[index].salaryRate);
                    },
                    widget: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: Dimensions.SIZE_DEFAULT,
                        right: Dimensions.SIZE_DEFAULT,
                        top: Dimensions.SIZE_SMALL,
                        bottom: Dimensions.SIZE_SMALL,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
                        ),
                      ),
                      child: Text(
                        '${_jobController.salaries[index].salaryRate}',
                        style: TextStyles.bodyTextBlack(context: context),
                      ),
                    ),
                  );
                }),
              ),
              addVerticalSpace(Dimensions.SIZE_DEFAULT),
              Text(
                'findByProvince'.tr,
                style: TextStyles.titleTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(_jobController.provinces.length, (index) {
                  return TouchAble(
                    radius: 5,
                    function: () {
                      _jobController.isJobsLoading.value = true;
                      Get.back();
                      _jobController.searchJob(filter: 'pv.province', value: _jobController.provinces[index].province);
                    },
                    widget: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: Dimensions.SIZE_DEFAULT,
                        right: Dimensions.SIZE_DEFAULT,
                        top: Dimensions.SIZE_SMALL,
                        bottom: Dimensions.SIZE_SMALL,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
                        ),
                      ),
                      child: Text(
                        '${_jobController.provinces[index].province}',
                        style: TextStyles.bodyTextBlack(context: context),
                      ),
                    ),
                  );
                }),
              ),
              addVerticalSpace(Dimensions.SIZE_DEFAULT),
              Text(
                'findByDistrict'.tr,
                style: TextStyles.titleTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(_jobController.districts.length, (index) {
                  return TouchAble(
                    radius: 5,
                    function: () {
                      _jobController.isJobsLoading.value = true;
                      Get.back();
                      _jobController.searchJob(filter: 'ds.district', value: _jobController.districts[index].district);
                    },
                    widget: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: Dimensions.SIZE_DEFAULT,
                        right: Dimensions.SIZE_DEFAULT,
                        top: Dimensions.SIZE_SMALL,
                        bottom: Dimensions.SIZE_SMALL,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
                        ),
                      ),
                      child: Text(
                        '${_jobController.districts[index].district}',
                        style: TextStyles.bodyTextBlack(context: context),
                      ),
                    ),
                  );
                }),
              ),
              addVerticalSpace(Dimensions.SIZE_DEFAULT),
              Text(
                'findByPosition'.tr,
                style: TextStyles.titleTextBlack(context: context, fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(_jobController.positions.length, (index) {
                  return TouchAble(
                    radius: 5,
                    function: () {
                      _jobController.isJobsLoading.value = true;
                      Get.back();
                      _jobController.searchJob(filter: 'p.position', value: _jobController.positions[index].position);
                    },
                    widget: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: Dimensions.SIZE_DEFAULT,
                        right: Dimensions.SIZE_DEFAULT,
                        top: Dimensions.SIZE_SMALL,
                        bottom: Dimensions.SIZE_SMALL,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
                        ),
                      ),
                      child: Text(
                        '${_jobController.positions[index].position}',
                        style: TextStyles.bodyTextBlack(context: context),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
