import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/user_controller.dart';
import 'package:good_job/controllers/setting_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
    Get.put(SettingController());
    Get.put(JobController());
  }
}
