import 'package:dagenergi/controllers/login_controller.dart';
import 'package:dagenergi/views/login/login_page.dart';
import 'package:dagenergi/views/tasks/tasks_page.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    final loginController = Get.find<LoginController>();
    Future.delayed(const Duration(seconds: 5), () {
      if(loginController.isLoggedIn.value) {
        Get.offAll(const TaskPage());
      } else{
        Get.off(const LogInPage());
      }
    });
  }
}
