import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/widgets/touch_able.dart';

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _jobController = Get.find<JobController>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.text = _jobController.searchValue.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _searchController,
      style: TextStyles.bodyTextBlack(context: context),
      cursorColor: Get.isDarkMode ? ColorSources.BLACK : ColorSources.WHITE,
      onFieldSubmitted: (_) {
        _jobController.isJobsLoading.value = true;
        if (_searchController.value.text == "") _jobController.findAllJob();
        _jobController.searchValue.value = _searchController.value.text;
        _jobController.searchJob(value: _searchController.value.text);
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.add_road, color: ColorSources.dynamicPrimary),
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                int selectedRadio = 0;
                if (_jobController.jobFilter.value == 'd.jobName') selectedRadio = 0;
                if (_jobController.jobFilter.value == 'c.companyName') selectedRadio = 1;
                if (_jobController.jobFilter.value == 'dg.degree') selectedRadio = 2;
                if (_jobController.jobFilter.value == 'm.major') selectedRadio = 3;

                return AlertDialog(
                  backgroundColor: ColorSources.backgroundColor(context),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Get.isDarkMode ? ColorSources.BLACK : ColorSources.WHITE,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List<Widget>.generate(
                            4,
                            (int index) {
                              String title;
                              if (index == 0) title = 'jobName'.tr;
                              if (index == 1) title = 'companyName'.tr;
                              if (index == 2) title = 'degree'.tr;
                              if (index == 3) title = 'major'.tr;
                              return ListTile(
                                title: TouchAble(
                                  function: () {
                                    if (index == 0) _jobController.jobFilter.value = 'd.jobName';
                                    if (index == 1) _jobController.jobFilter.value = 'c.companyName';
                                    if (index == 2) _jobController.jobFilter.value = 'dg.degree';
                                    if (index == 3) _jobController.jobFilter.value = 'm.major';
                                    setState(() => selectedRadio = index);
                                  },
                                  radius: 5,
                                  widget: Text(
                                    title,
                                    style: TextStyles.bodyTextBlack(context: context),
                                  ),
                                ),
                                leading: Radio<int>(
                                  activeColor: ColorSources.dynamicPrimary,
                                  value: index,
                                  groupValue: selectedRadio,
                                  onChanged: (int value) {
                                    if (value == 0) _jobController.jobFilter.value = 'd.jobName';
                                    if (value == 1) _jobController.jobFilter.value = 'c.companyName';
                                    if (value == 2) _jobController.jobFilter.value = 'dg.degree';
                                    if (value == 3) _jobController.jobFilter.value = 'm.major';
                                    setState(() => selectedRadio = value);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
          splashColor: Colors.transparent,
        ),
        labelText: 'search'.tr,
        labelStyle: TextStyle(
          color: Get.isDarkMode ? ColorSources.BLACK : ColorSources.WHITE,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        filled: true,
        fillColor: Get.isDarkMode ? ColorSources.WHITE : Color(0xff4f5f70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Get.isDarkMode ? ColorSources.SECONDARY : ColorSources.WHITE,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
