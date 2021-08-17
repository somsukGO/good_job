import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../main.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  var isDarkMode = false.obs;

  @override
  void onInit() {
    bool getThemeMode = _storage.read('isDarkMode');
    isDarkMode.value = getThemeMode == null || getThemeMode == false ? false : true;
    super.onInit();
  }

  void loadTheme() {
    MyApp.themeNotifier.value = isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    MyApp.themeNotifier.value = isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
    _storage.write('isDarkMode', isDarkMode.value);
  }
}
