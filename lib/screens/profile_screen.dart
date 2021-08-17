import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_job/Utils/app_constants.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/image_sources.dart';
import 'package:good_job/Utils/text_styles.dart';
import 'package:good_job/Utils/utils.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/component/custom_drawer.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/models/district.dart';
import 'package:good_job/models/my_response.dart';
import 'package:good_job/models/province.dart';
import 'package:good_job/models/users.dart';
import 'package:good_job/widgets/custom_password_field.dart';
import 'package:good_job/widgets/custom_text_form_field.dart';
import 'package:good_job/widgets/full_width_button.dart';
import 'package:good_job/widgets/touch_able.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static final String routeName = '/profile-screen-detail';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userC = Get.find<UserController>();
  final _jobController = Get.find<JobController>();

  final firstNameC = TextEditingController();
  final lastNameC = TextEditingController();
  final phoneNumberC = TextEditingController();
  final emailC = TextEditingController();
  final addressC = TextEditingController();
  final passC = TextEditingController();
  final newPasswordC = TextEditingController();
  final rePassC = TextEditingController();

  final passF = FocusNode();
  final rePassF = FocusNode();

  @override
  void dispose() {
    newPasswordC.dispose();
    rePassC.dispose();
    firstNameC.dispose();
    lastNameC.dispose();
    phoneNumberC.dispose();
    emailC.dispose();
    addressC.dispose();
    passC.dispose();
    passF.dispose();
    rePassF.dispose();

    super.dispose();
  }

  String dob;
  String base64Image = "";
  String gender = "";

  @override
  void initState() {
    dob = _userC.user.value.dob;
    firstNameC.text = _userC.user.value.memberName;
    lastNameC.text = _userC.user.value.memberLastname;
    phoneNumberC.text = _userC.user.value.phonenumber;
    emailC.text = _userC.user.value.email;
    gender = _userC.user.value.gender;
    addressC.text = _userC.user.value.memberAddress;
    passC.text = _userC.user.value.password ?? '';

    super.initState();
  }

  final profileForm = GlobalKey<FormState>();
  final changePasswordForm = GlobalKey<FormState>();

  bool isUpdating = false;
  bool isPasswordChanging = false;

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

  Future<String> _getImageBase64() async {
    if (_userC.user.value.image != "" && _userC.user.value.image != null) {
      final imageResponse = await http.get(Uri.http('216.127.173.163', 'goodjob/image/${_userC.user.value.image}'));
      return base64Encode(imageResponse.bodyBytes);
    }
    return "";
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

  final _storage = GetStorage();

  String districtId = "1";
  String provinceId = "1";

  void loadAddress() {
    _jobController.loadProvince().then((_) {
      _jobController.loadDistrict().then((_) {
        setState(() {
          if (_jobController.provinces.isNotEmpty)
            _jobController.province.value =
                _jobController.provinces.firstWhere((element) => element.id == _userC.user.value.provinceId).province;
          if (_jobController.districts.isNotEmpty)
            _jobController.district.value =
                _jobController.districts.firstWhere((element) => element.districtId == _userC.user.value.districtId).district;
          _jobController.isAddressLoaded.value = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_jobController.isAddressLoaded.value) loadAddress();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSources.dynamicPrimary,
        title: Text(
          'update'.tr,
          style: TextStyle(
            color: ColorSources.WHITE,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark,
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorSources.dynamicPrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                left: Dimensions.SIZE_DEFAULT,
                right: Dimensions.SIZE_DEFAULT,
                bottom: Dimensions.SIZE_DEFAULT,
              ),
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TouchAble(
                    radius: 60,
                    function: () {
                      _chooseImageSource();
                    },
                    widget: Stack(
                      // alignment: Alignment.topCenter,
                      children: [
                        ClipRRect(
                          child: _image == null
                              ? _userC.user.value.image == "" || _userC.user.value.image == null
                                  ? Image.asset(
                                      ImageSources.PROFILE_AVATAR,
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    )
                                  : Obx(
                                      () => Image.network(
                                        '$IMAGE_URL/${_userC.user.value.image}',
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                              : Image.file(
                                  _image,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   child: Container(
                        //     alignment: Alignment.centerRight,
                        //     width: 75,
                        //     child: TouchAble(
                        //       function: () {
                        //         _chooseImageSource();
                        //       },
                        //       widget: Icon(
                        //         CupertinoIcons.camera,
                        //         color: ColorSources.WHITE,
                        //         size: 30,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        child: Obx(
                          () => Text(
                            "${_userC.user.value.memberName} ${_userC.user.value.memberLastname}",
                            style: TextStyles.staticBodyTextWhite(
                              context: context,
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      addVerticalSpace(Dimensions.SIZE_SMALL),
                      Container(
                        width: 180,
                        child: Obx(
                          () => Text(
                            "${_userC.user.value.phonenumber}",
                            style: TextStyles.staticBodyTextWhite(
                              context: context,
                              fontWeight: FontWeight.w600,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimensions.SIZE_DEFAULT),
              child: Form(
                key: profileForm,
                child: Column(
                  children: [
                    CustomTextFormField(
                      textEditingController: firstNameC,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.text,
                      borderWidth: 1.5,
                      labelText: 'firstName'.tr,
                    ),
                    addVerticalSpace(Dimensions.SIZE_DEFAULT),
                    CustomTextFormField(
                      textEditingController: lastNameC,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.text,
                      borderWidth: 1.5,
                      labelText: 'lastName'.tr,
                    ),
                    addVerticalSpace(Dimensions.SIZE_DEFAULT),
                    CustomTextFormField(
                      textEditingController: phoneNumberC,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      borderWidth: 1.5,
                      labelText: 'phoneNumber'.tr,
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
                      radius: 5,
                      function: () {
                        Get.defaultDialog(
                          backgroundColor: ColorSources.backgroundColor(context),
                          title: 'changePassword'.tr,
                          titleStyle: TextStyles.titleTextBlack(
                            context: context,
                            fontSize: 18,
                          ),
                          content: Form(
                            key: changePasswordForm,
                            child: Column(
                              children: [
                                CustomPasswordField(
                                  textInputAction: TextInputAction.next,
                                  textEditingController: newPasswordC,
                                  labelText: 'password'.tr,
                                  validator: (value) {
                                    if (value.isEmpty) return 'pleaseEnterAPassword'.tr;
                                    if (value.toString().length < 6 || value.toString().length > 20)
                                      return 'lengthShouldBe6To20'.tr;
                                    if (value.toString().contains(" ")) return 'whiteSpaceNotAllowHere'.tr;
                                    return null;
                                  },
                                ),
                                addVerticalSpace(Dimensions.SIZE_EXTRA_LARGE),
                                CustomPasswordField(
                                  textInputAction: TextInputAction.done,
                                  labelText: 'confirmPassword'.tr,
                                  textEditingController: rePassC,
                                  validator: (value) {
                                    if (value.isEmpty) return 'pleaseEnterAPassword'.tr;
                                    if (value.toString().length < 6 || value.toString().length > 20)
                                      return 'lengthShouldBe6To20'.tr;
                                    if (value.toString().contains(" ")) return 'whiteSpaceNotAllowHere'.tr;
                                    if (value.toString() != newPasswordC.value.text) return 'passwordDoesMatch'.tr;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          confirm: TextButton(
                            onPressed: () async {
                              if (!changePasswordForm.currentState.validate())
                                return Utils.snackbar(
                                  context: context,
                                  title: 'changePasswordFail'.tr,
                                  message: 'fillAllField'.tr,
                                  color: ColorSources.RED,
                                );

                              Navigator.of(context).pop();

                              this.setState(() {
                                isPasswordChanging = true;
                              });

                              MyResponse response = await _userC.changePassword(newPasswordC.value.text);

                              if (response.status == '1') {
                                Utils.snackbar(
                                  context: context,
                                  title: 'changePasswordSuccess'.tr,
                                  message: response.message,
                                );
                              } else {
                                Utils.snackbar(
                                  context: context,
                                  title: 'changePasswordFail'.tr,
                                  message: response.message,
                                  color: ColorSources.RED,
                                );
                              }

                              newPasswordC.clear();
                              rePassC.clear();

                              this.setState(() => isPasswordChanging = false);
                            },
                            child: Text('Ok'),
                          ),
                          radius: 5,
                        );
                      },
                      widget: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                          color: Get.isDarkMode ? ColorSources.WHITE : ColorSources.DARK_BLUE,
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        child: isPasswordChanging
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SpinKitFadingCircle(
                                    color: ColorSources.dynamicPrimary,
                                    size: 24.0,
                                  ),
                                  addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                                  Text(
                                    "${'updating'.tr}...",
                                    style: TextStyles.bodyTextBlack(context: context),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'changePassword'.tr,
                                    style: TextStyles.bodyTextBlack(context: context, fontWeight: FontWeight.w500),
                                  ),
                                  Icon(Icons.edit, color: Colors.grey),
                                ],
                              ),
                      ),
                    ),
                    addVerticalSpace(Dimensions.SIZE_DEFAULT),
                    CustomTextFormField(
                      textEditingController: emailC,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      borderWidth: 1.5,
                      labelText: 'email'.tr,
                    ),
                    addVerticalSpace(Dimensions.SIZE_SMALL),
                    if (gender == 'ຊາຍ' || gender == 'ຍິງ' || gender == 'ອື່ນໆ')
                      Row(
                        children: [
                          Text('gender'.tr, style: TextStyles.bodyTextBlack(context: context)),
                          addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                          DropdownButton<String>(
                            icon: Icon(Icons.arrow_drop_down, color: ColorSources.dynamicPrimary),
                            style: TextStyles.bodyTextBlack(context: context),
                            dropdownColor: ColorSources.backgroundColor(context),
                            items: <String>['ຊາຍ', 'ຍິງ', 'ອື່ນໆ'].map((String value) {
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
                                              provinceId =
                                                  _jobController.provinces.firstWhere((element) => element.province == value).id;
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
                    addVerticalSpace(Dimensions.SIZE_SMALL),
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
                      textEditingController: addressC,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.multiline,
                      maxLine: 2,
                      borderWidth: 1.5,
                      labelText: 'address'.tr,
                    ),
                    addVerticalSpace(Dimensions.SIZE_DEFAULT),
                    isUpdating
                        ? Container(
                            decoration: BoxDecoration(
                              color: ColorSources.dynamicPrimary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SpinKitFadingCircle(
                                  color: ColorSources.WHITE,
                                  size: 30.0,
                                ),
                                addHorizontalSpace(Dimensions.SIZE_DEFAULT),
                                Text(
                                  "${'updating'.tr}...",
                                  style: TextStyles.staticBodyTextWhite(),
                                ),
                              ],
                            ),
                          )
                        : FullWidthButton(
                            title: 'update'.tr,
                            function: () async {
                              FocusScope.of(context).unfocus();

                              if (!profileForm.currentState.validate())
                                return Utils.errorDialog(
                                  context: context,
                                  title: 'fillAllField'.tr,
                                );

                              this.setState(() {
                                isUpdating = true;
                              });

                              if (base64Image == "") {
                                base64Image = await _getImageBase64();
                              }

                              final user = Users(
                                id: _storage.read(USER_ID).toString(),
                                memberName: firstNameC.value.text,
                                memberLastname: lastNameC.value.text,
                                phonenumber: phoneNumberC.value.text,
                                email: emailC.value.text,
                                gender: gender,
                                memberAddress: addressC.value.text,
                                dob: dob,
                                password: passC.value.text,
                                image: base64Image,
                                provinceId: provinceId,
                                districtId: districtId,
                              );

                              MyResponse response = await _userC.updateProfile(user);

                              if (response.status == '1') {
                                Utils.infoDialog(
                                  context: context,
                                  title: 'updateProfileSuccess'.tr,
                                );

                                await _userC.getMember();

                                base64Image = "";
                              } else {
                                Utils.errorDialog(
                                  context: context,
                                  title: response.message,
                                );
                              }
                              this.setState(() => isUpdating = false);
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: ColorSources.backgroundColor(context),
    );
  }
}
