import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_job/Utils/color_sources.dart';
import 'package:good_job/Utils/dimensions.dart';
import 'package:good_job/Utils/image_sources.dart';
import 'package:good_job/Utils/utils.dart';
import 'package:good_job/Utils/widget_functions.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/models/my_response.dart';
import 'package:good_job/models/users.dart';
import 'package:good_job/screens/auth_screen/register_screen.dart';
import 'package:good_job/widgets/custom_password_field.dart';
import 'package:good_job/widgets/custom_text_form_field.dart';
import 'package:good_job/widgets/full_width_button.dart';
import 'package:good_job/widgets/loading.dart';

import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  static final String routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoggingIn = false;

  final uC = TextEditingController();
  final pC = TextEditingController();

  @override
  void dispose() {
    uC.dispose();
    pC.dispose();
    super.dispose();
  }

  final loginForm = GlobalKey<FormState>();

  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_userController.fromLogout.value) {
        Utils.snackbar(context: context, title: 'logoutSuccess'.tr, message: 'goodBye'.tr);
        _userController.fromLogin.value = true;
        _userController.fromLogout.value = false;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.SIZE_DEFAULT),
                  child: Form(
                    key: loginForm,
                    child: Column(
                      children: [
                        addVerticalSpace(Dimensions.SIZE_DEFAULT),
                        Image(
                          fit: BoxFit.fill,
                          image: AssetImage(ImageSources.USER_AUTH),
                          width: 220,
                          height: 200,
                        ),
                        addVerticalSpace(Dimensions.SIZE_EXTRA_LARGE),
                        CustomTextFormField(
                          // prefix: Container(
                          //   padding: EdgeInsets.only(top: 14, left: 10),
                          //   child: Text(
                          //     '020',
                          //     style: TextStyles.bodyTextBlack(context: context),
                          //   ),
                          // ),
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.number,
                          borderWidth: 1.5,
                          labelText: 'phoneNumber'.tr,
                          textEditingController: uC,
                          validator: (value) {
                            if (value.isEmpty) return 'pleaseEnterAPhoneNumber'.tr;
                            if (double.tryParse(value) == null) return 'pleaseEnterAValidNumber'.tr;
                            if (value.toString().length < 8) return 'lengthShouldBe8Digit'.tr;
                            if (value.toString().contains(" ")) return 'whiteSpaceNotAllowHere'.tr;
                            return null;
                          },
                        ),
                        addVerticalSpace(Dimensions.SIZE_EXTRA_LARGE),
                        CustomPasswordField(
                          textEditingController: pC,
                          textInputAction: TextInputAction.done,
                          labelText: 'password'.tr,
                          validator: (value) {
                            if (value.isEmpty) return 'pleaseEnterAPassword'.tr;
                            if (value.toString().length < 6 || value.toString().length > 20) return 'lengthShouldBe6To20'.tr;
                            if (value.toString().contains(" ")) return 'whiteSpaceNotAllowHere'.tr;
                            return null;
                          },
                        ),
                        addVerticalSpace(Dimensions.SIZE_EXTRA_LARGE),
                        FullWidthButton(
                          title: 'login'.tr,
                          function: () async {
                            if (!loginForm.currentState.validate())
                              return Utils.snackbar(
                                context: context,
                                title: 'loginFail'.tr,
                                message: 'fillAllField'.tr,
                                color: ColorSources.RED,
                              );

                            this.setState(() {
                              isLoggingIn = true;
                            });

                            final user = Users(phonenumber: '${uC.value.text}', password: pC.value.text);

                            MyResponse response = await _userController.login(user);

                            if (response.status == '1') {
                              Get.find<JobController>().isAddressLoaded.value = false;
                              Get.offAllNamed(HomeScreen.routeName);
                            } else {
                              Utils.snackbar(
                                context: context,
                                title: 'loginFail'.tr,
                                message: response.message,
                                color: ColorSources.RED,
                              );
                              setState(() => isLoggingIn = false);
                            }
                          },
                        ),
                        addVerticalSpace(Dimensions.SIZE_LARGE),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'donNotHaveAccount'.tr,
                              style: TextStyle(color: ColorSources.black(context), fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.offNamed(RegisterScreen.routeName);
                              },
                              child: Text('register'.tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isLoggingIn) Loading(title: 'loggingIn'.tr),
          ],
        ),
      ),
      backgroundColor: ColorSources.backgroundColor(context),
    );
  }
}
