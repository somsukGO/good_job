import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingController extends GetxController {
  final _storage = GetStorage();
  var selectedLanguage = Get.locale.languageCode.obs;

  set changeLanguage(String lang) {
    Locale locale = new Locale(lang);
    Get.updateLocale(locale);
    selectedLanguage.value = lang;
    _storage.write('local', lang);
  }
}
