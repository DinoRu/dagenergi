import 'package:dagenergi/controllers/login_controller.dart';
import 'package:dagenergi/views/login/login_page.dart';
import 'package:dagenergi/views/tasks/tasks_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Map<String, dynamic>? user = GetStorage().read('loginUser');
    Future.delayed(const Duration(seconds: 5), () {
      if (user != null) {
        Get.offAll(() => const TaskPage());
      } else {
        Get.off(const LogInPage());
      }
    });
  }
}
