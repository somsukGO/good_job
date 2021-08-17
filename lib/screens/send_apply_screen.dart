import 'package:flutter/material.dart';
import 'package:good_job/Utils/app_constants.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:good_job/Utils/utils.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/models/apply.dart';
import 'package:good_job/models/degree.dart';
import 'package:good_job/widgets/custom_text_form_field.dart';
import 'package:good_job/widgets/loading.dart';
import 'package:good_job/widgets/touch_able.dart';

class SendApplyScreen extends StatefulWidget {
  static final String routeName = '/send-apply-screen';

  @override
  _SendApplyScreenState createState() => _SendApplyScreenState();
}

class _SendApplyScreenState extends State<SendApplyScreen> {
  final sendApplyForm = GlobalKey<FormState>();
  final _userC = Get.find<UserController>();
  final _jobController = Get.find<JobController>();

  final pC = TextEditingController();
  final nC = TextEditingController();
  final lNC = TextEditingController();
  final eC = TextEditingController();
  final gC = TextEditingController();
  final dobC = TextEditingController();
  final adC = TextEditingController();
  final desC = TextEditingController();

  String dob = 'dateOfBirth'.tr;

  @override
  void dispose() {
    desC.dispose();
    pC.dispose();
    nC.dispose();
    lNC.dispose();
    gC.dispose();
    dobC.dispose();
    adC.dispose();
    super.dispose();
  }

  String degree;

  @override
  void initState() {
    dob = _userC.user.value.dob;
    nC.text = _userC.user.value.memberName;
    lNC.text = _userC.user.value.memberLastname;
    pC.text = _userC.user.value.phonenumber;
    eC.text = _userC.user.value.email;
    gC.text = _userC.user.value.gender;
    adC.text = _userC.user.value.memberAddress;
    pC.text = _userC.user.value.phonenumber;
    _jobController.applyingDegree.value = _jobController.degrees[0].degree;
    super.initState();
  }

  bool isSending = false;
  final apply = Get.arguments as Apply;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSources.dynamicPrimary,
        title: Text(
          'sendApply'.tr,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.SIZE_DEFAULT),
              child: Column(
                children: [
                  Form(
                    key: sendApplyForm,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                          borderWidth: 1.5,
                          labelText: 'name'.tr,
                          textEditingController: nC,
                          validator: (value) {
                            if (value.isEmpty) return 'pleaseEnterName'.tr;
                            return null;
                          },
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        CustomTextFormField(
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                          borderWidth: 1.5,
                          labelText: 'lastName'.tr,
                          textEditingController: lNC,
                          validator: (value) {
                            if (value.isEmpty) return 'pleaseEnterSurname'.tr;
                            return null;
                          },
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        CustomTextFormField(
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.emailAddress,
                          borderWidth: 1.5,
                          labelText: 'email'.tr,
                          textEditingController: eC,
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        CustomTextFormField(
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                          borderWidth: 1.5,
                          labelText: 'gender'.tr,
                          textEditingController: gC,
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        TouchAble(
                          widget: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? ColorSources.WHITE : ColorSources.DARK_BLUE,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey.shade300, width: 1.5),
                            ),
                            child: Text(
                              dob,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w500),
                            ),
                          ),
                          function: () async {
                            final pickedDate = await Utils.selectDate(context: context, lastDate: DateTime.now());
                            if (pickedDate != null) {
                              setState(() {
                                dob = pickedDate.toString().split(" ")[0];
                              });
                            }
                          },
                          radius: 5,
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        CustomTextFormField(
                          textEditingController: adC,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.multiline,
                          maxLine: 2,
                          borderWidth: 1.5,
                          labelText: 'address'.tr,
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        CustomTextFormField(
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.number,
                          borderWidth: 1.5,
                          labelText: 'phoneNumber'.tr,
                          textEditingController: pC,
                          validator: (value) {
                            if (value.isEmpty) return 'pleaseEnterAPhoneNumber'.tr;
                            if (double.tryParse(value) == null) return 'pleaseEnterAValidNumber'.tr;
                            if (value.toString().length < 8) return 'lengthShouldBe8Digit'.tr;
                            if (value.toString().contains(" ")) return 'whiteSpaceNotAllowHere'.tr;
                            return null;
                          },
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text('degree'.tr, style: TextStyles.bodyTextBlack(context: context)),
                                  addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                                  DropdownButton<String>(
                                    icon: Icon(Icons.arrow_drop_down, color: ColorSources.dynamicPrimary),
                                    style: TextStyles.bodyTextBlack(context: context),
                                    dropdownColor: ColorSources.backgroundColor(context),
                                    items: _jobController.degrees.map((Degree degree) {
                                      return DropdownMenuItem<String>(
                                        value: degree.degree,
                                        child: new Text(degree.degree),
                                      );
                                    }).toList(),
                                    value: _jobController.applyingDegree.value,
                                    onChanged: (value) {
                                      setState(() {
                                        _jobController.applyingDegree.value = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        CustomTextFormField(
                          textEditingController: desC,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.multiline,
                          maxLine: 2,
                          borderWidth: 1.5,
                          labelText: 'description'.tr,
                        ),
                      ],
                    ),
                  ),
                  addVerticalSpace(Dimensions.SIZE_DEFAULT),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isSending = true;
                      });
                      apply.applyDescription = desC.value.text;
                      int degreeId = int.parse(_jobController.degrees
                          .firstWhere((element) => element.degree == _jobController.applyingDegree.value)
                          .id);
                      apply.degreeId = degreeId;

                      print('id: ${apply.degreeId}');
                      final response = await _jobController.applyJob(apply);

                      desC.clear();

                      if (response.status == SUCCESS) {
                        Utils.infoDialog(
                          context: context,
                          title: 'applyingSuccess'.tr,
                          function: () => Get.back(),
                        );
                        setState(() {
                          isSending = false;
                        });
                      } else {
                        Utils.errorDialog(
                          context: context,
                          title: response.message,
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                      child: Text(
                        'send'.tr,
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
      backgroundColor: ColorSources.backgroundColor(context),
    );
  }
}
