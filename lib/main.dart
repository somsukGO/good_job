import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_job/Utils/app_translation.dart';
import 'package:good_job/controllers/job_controller.dart';
import 'package:good_job/controllers/themeController.dart';
import 'package:good_job/onboarding/onboarding_screen.dart';
import 'package:good_job/screens/about_us_screen.dart';
import 'package:good_job/screens/applying_detail_screen.dart';
import 'package:good_job/screens/applying_screen.dart';
import 'package:good_job/screens/auth_screen/login_screen.dart';
import 'package:good_job/screens/auth_screen/register_screen.dart';
import 'package:good_job/screens/home_screen.dart';
import 'package:good_job/screens/job_detail_screen.dart';
import 'package:good_job/screens/profile_screen.dart';
import 'package:good_job/screens/send_apply_screen.dart';
import 'package:good_job/screens/setting_screen.dart';
import 'package:good_job/theme/dark_theme.dart';
import 'package:good_job/theme/light_theme.dart';

import 'Utils/app_constants.dart';
import 'controllers/controller_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  await GetStorage.init();
  Get.put(ThemeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  final _themeController = Get.find<ThemeController>();
  final _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    _themeController.loadTheme();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    String local = _storage.read('local');
    local = local == null ? 'lo' : local;

    bool isLogin = _storage.read(TOKEN) != null;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return GetMaterialApp(
          title: 'goodJob'.tr,
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentMode,
          initialBinding: ControllerBinding(),
          getPages: [
            GetPage(name: HomeScreen.routeName, page: () => HomeScreen()),
            GetPage(name: ProfileScreen.routeName, page: () => ProfileScreen()),
            GetPage(name: JobDetailScreen.routeName, page: () => JobDetailScreen()),
            GetPage(name: OnboardingScreen.routeName, page: () => OnboardingScreen()),
            GetPage(name: LoginScreen.routeName, page: () => LoginScreen()),
            GetPage(name: RegisterScreen.routeName, page: () => RegisterScreen()),
            GetPage(name: SettingScreen.routeName, page: () => SettingScreen()),
            GetPage(name: ProfileScreen.routeName, page: () => ProfileScreen()),
            GetPage(name: ApplyingScreen.routeName, page: () => ApplyingScreen()),
            GetPage(name: ApplyingDetailScreen.routeName, page: () => ApplyingDetailScreen()),
            GetPage(name: AboutUsScreen.routeName, page: () => AboutUsScreen()),
            GetPage(name: SendApplyScreen.routeName, page: () => SendApplyScreen()),
          ],
          defaultTransition: Transition.cupertino,
          home: isLogin ? HomeScreen() : OnboardingScreen(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('lo'),
          ],
          // locale: Get.deviceLocale,
          locale: new Locale(local),
          fallbackLocale: Locale('en', 'US'),
          translationsKeys: AppTranslation.translationsKeys,
        );
      },
    );
  }
}
