import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/image_sources.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:good_job/Utils/utils.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/models/district.dart';
import 'package:good_job/models/my_response.dart';
import 'package:good_job/models/province.dart';
import 'package:good_job/models/users.dart';
import 'package:good_job/screens/auth_screen/login_screen.dart';
import 'package:good_job/screens/home_screen.dart';
import 'package:good_job/widgets/custom_password_field.dart';
import 'package:good_job/widgets/custom_text_form_field.dart';
import 'package:good_job/widgets/full_width_button.dart';
import 'package:good_job/widgets/loading.dart';
import 'package:good_job/widgets/touch_able.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  static final String routeName = '/register-screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userController = Get.find<UserController>();
  final _jobController = Get.find<JobController>();

  final registerForm = GlobalKey<FormState>();

  final uC = TextEditingController();
  final pC = TextEditingController();
  final rPC = TextEditingController();
  final nC = TextEditingController();
  final lNC = TextEditingController();
  final eC = TextEditingController();
  final dobC = TextEditingController();
  final adC = TextEditingController();

  final uF = FocusNode();
  final pF = FocusNode();
  final rPF = FocusNode();

  @override
  void dispose() {
    uC.dispose();
    pC.dispose();
    rPC.dispose();
    uF.dispose();
    pF.dispose();
    rPF.dispose();
    nC.dispose();
    lNC.dispose();
    dobC.dispose();
    adC.dispose();
    super.dispose();
  }

  void loadProvince() async {
    await _jobController.loadProvince();
  }

  String gender = "ອື່ນໆ";
  String dob = 'dateOfBirth'.tr;

  bool isRegistering = false;
  bool isRegisterSuccess = false;

  String base64Image = "";
  File _image;
  final ImagePicker _picker = ImagePicker();

  Future _pickImage(ImageSource imageSource) async {
    final pickedFile = await _picker.pickImage(
      source: imageSource,
      imageQuality: 75,
      maxHeight: 512,
      maxWidth: 512,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    List<int> imageBytes = await _image.readAsBytes();
    base64Image = base64Encode(imageBytes);

    print('pickedImageBase64: $base64Image');
  }

  Future _chooseImageSource() async {
    Get.defaultDialog(
      title: 'imageFrom'.tr,
      titleStyle: TextStyles.titleTextBlack(context: context),
      backgroundColor: ColorSources.backgroundColor(context),
      radius: 10,
      content: Column(
        children: [
          TextButton(
            onPressed: () {
              _pickImage(ImageSource.camera);
              Navigator.of(context).pop();
            },
            child: Text('camera'.tr),
          ),
          TextButton(
            onPressed: () {
              _pickImage(ImageSource.gallery);
              Navigator.of(context).pop();
            },
            child: Text('gallery'.tr),
          ),
        ],
      ),
    );
  }

  void loadAddress() {
    _jobController.loadProvince().then((_) {
      _jobController.loadDistrict().then((_) {
        setState(() {
          if (_jobController.provinces.isNotEmpty) _jobController.province.value = _jobController.provinces[0].province;
          if (_jobController.districts.isNotEmpty) _jobController.district.value = _jobController.districts[0].district;
          _jobController.isAddressLoaded.value = true;
        });
      });
    });
  }

  String districtId = "1";
  String provinceId = "1";

  @override
  Widget build(BuildContext context) {
    if (!_jobController.isAddressLoaded.value) loadAddress();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                  child: Form(
                    key: registerForm,
                    child: Column(
                      children: [
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        TouchAble(
                          radius: 60,
                          function: () {
                            _chooseImageSource();
                          },
                          widget: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              ClipRRect(
                                child: _image == null
                                    ? Image.asset(
                                        ImageSources.PROFILE_AVATAR,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        _image,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 75,
                                  child: TouchAble(
                                    function: () {
                                      _chooseImageSource();
                                    },
                                    widget: Icon(
                                      CupertinoIcons.camera,
                                      color: ColorSources.dynamicPrimary,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
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
                          textInputType: TextInputType.number,
                          borderWidth: 1.5,
                          labelText: 'phoneNumber'.tr,
                          textEditingController: uC,
                          focusNode: uF,
                          validator: (value) {
                            if (value.isEmpty) return 'pleaseEnterAPhoneNumber'.tr;
                            if (double.tryParse(value) == null) return 'pleaseEnterAValidNumber'.tr;
                            if (value.toString().length < 8) return 'lengthShouldBe8Digit'.tr;
                            if (value.toString().contains(" ")) return 'whiteSpaceNotAllowHere'.tr;
                            return null;
                          },
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text('gender'.tr, style: TextStyles.bodyTextBlack(context: context)),
                                  addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                                  DropdownButton<String>(
                                    icon: Icon(Icons.arrow_drop_down, color: ColorSources.dynamicPrimary),
                                    style: TextStyles.bodyTextBlack(context: context),
                                    dropdownColor: ColorSources.backgroundColor(context),
                                    items: <String>['male'.tr, 'female'.tr, 'other'.tr].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                    value: gender,
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _jobController.isAddressLoaded.value
                            ? _jobController.provinces.isEmpty
                                ? Container()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Text('province'.tr, style: TextStyles.bodyTextBlack(context: context)),
                                            addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                                            DropdownButton<String>(
                                              icon: Icon(Icons.arrow_drop_down, color: ColorSources.dynamicPrimary),
                                              style: TextStyles.bodyTextBlack(context: context),
                                              dropdownColor: ColorSources.backgroundColor(context),
                                              items: _jobController.provinces.map((Province province) {
                                                return DropdownMenuItem<String>(
                                                  value: province.province,
                                                  child: new Text(province.province),
                                                );
                                              }).toList(),
                                              value: _jobController.province.value,
                                              onChanged: (value) {
                                                setState(() {
                                                  _jobController.province.value = value;
                                                  provinceId = _jobController.provinces
                                                      .firstWhere((element) => element.province == value)
                                                      .id;
                                                  try {
                                                    districtId = _jobController.districts
                                                        .firstWhere((element) => element.province == value)
                                                        .districtId;
                                                  } catch (err) {
                                                    districtId = '1';
                                                  }
                                                  _jobController.district.value = _jobController.districts
                                                      .firstWhere((element) => element.districtId == districtId)
                                                      .district;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                            : Row(
                                children: [
                                  SpinKitFadingCircle(
                                    color: ColorSources.dynamicPrimary,
                                    size: 25.0,
                                  ),
                                ],
                              ),
                        addVerticalSpace(Dimensions.SIZE_SMALL),
                        _jobController.isAddressLoaded.value
                            ? _jobController.district.isEmpty
                                ? Container()
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Text('district'.tr, style: TextStyles.bodyTextBlack(context: context)),
                                            addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                                            DropdownButton<String>(
                                              icon: Icon(Icons.arrow_drop_down, color: ColorSources.dynamicPrimary),
                                              style: TextStyles.bodyTextBlack(context: context),
                                              dropdownColor: ColorSources.backgroundColor(context),
                                              items: _jobController.districts.map((District district) {
                                                return DropdownMenuItem<String>(
                                                  value: district.district,
                                                  child: new Text(district.district),
                                                );
                                              }).toList(),
                                              value: _jobController.district.value,
                                              onChanged: (value) {
                                                setState(() {
                                                  _jobController.district.value = value;
                                                  final province = _jobController.districts
                                                      .firstWhere((element) => element.district == value)
                                                      .province;
                                                  _jobController.province.value = province;
                                                  districtId = _jobController.districts
                                                      .firstWhere((element) => element.district == value)
                                                      .districtId;
                                                  provinceId = _jobController.provinces
                                                      .firstWhere((element) => element.province == province)
                                                      .id;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                            : Row(
                                children: [
                                  SpinKitFadingCircle(
                                    color: ColorSources.dynamicPrimary,
                                    size: 25.0,
                                  ),
                                ],
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
                          textEditingController: adC,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.multiline,
                          maxLine: 2,
                          borderWidth: 1.5,
                          labelText: 'address'.tr,
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        CustomPasswordField(
                          focusNode: pF,
                          textInputAction: TextInputAction.next,
                          textEditingController: pC,
                          labelText: 'password'.tr,
                          validator: (value) {
                            if (value.isEmpty) return 'pleaseEnterAPassword'.tr;
                            if (value.toString().length < 6 || value.toString().length > 20) return 'lengthShouldBe6To20'.tr;
                            if (value.toString().contains(" ")) return 'whiteSpaceNotAllowHere'.tr;
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(rPF);
                          },
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        CustomPasswordField(
                          focusNode: rPF,
                          textInputAction: TextInputAction.done,
                          labelText: 'confirmPassword'.tr,
                          textEditingController: rPC,
                          validator: (value) {
                            if (value.isEmpty) return 'pleaseEnterAPassword'.tr;
                            if (value.toString().length < 6 || value.toString().length > 20) return 'lengthShouldBe6To20'.tr;
                            if (value.toString().contains(" ")) return 'whiteSpaceNotAllowHere'.tr;
                            if (value.toString() != pC.value.text) return 'passwordDoesMatch'.tr;
                            return null;
                          },
                        ),
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        FullWidthButton(
                          title: 'register'.tr,
                          function: () async {
                            if (!registerForm.currentState.validate())
                              return Utils.snackbar(
                                context: context,
                                title: 'registerFail'.tr,
                                message: 'fillAllField'.tr,
                                color: ColorSources.RED,
                              );

                            this.setState(() {
                              isRegistering = true;
                            });

                            final user = Users(
                              phonenumber: uC.value.text,
                              password: pC.value.text,
                              memberName: nC.value.text,
                              memberLastname: lNC.value.text,
                              email: eC.value.text,
                              gender: gender,
                              image: base64Image,
                              dob: dob,
                              memberAddress: adC.value.text,
                              districtId: districtId,
                              provinceId: provinceId,
                            );
                            MyResponse registerResponse = await _userController.register(user);

                            if (registerResponse.status == '1') {
                              Get.offAllNamed(HomeScreen.routeName);
                            } else {
                              Utils.snackbar(
                                context: context,
                                title: 'registerFail'.tr,
                                message: registerResponse.message,
                                color: ColorSources.RED,
                              );
                              this.setState(() => isRegistering = false);
                            }
                          },
                        ),
                        addVerticalSpace(Dimensions.SIZE_LARGE),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'alreadyHaveAccount'.tr,
                              style: TextStyle(color: ColorSources.black(context), fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                              onPressed: () async {
                                Get.offNamed(LoginScreen.routeName);
                              },
                              child: Text('login'.tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isRegistering) Loading(title: 'registering'.tr),
          ],
        ),
      ),
      backgroundColor: ColorSources.backgroundColor(context),
    );
  }
}
