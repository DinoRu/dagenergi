import 'package:dagenergi/views/login/login_page.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      Get.off(const LogInPage());
    });
  }
}
