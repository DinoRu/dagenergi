import 'package:dagenergi/views/tasks/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoggedIn = false.obs;
  GetStorage box = GetStorage();

  void login() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == 'admin' && password == 'admin') {
      Map<String, dynamic> userData = {
        'username': 'admin',
        'password': 'admin'
      };
      box.write('loginUser', userData);
      Get.offAll(const TaskPage());
    } else {
      Get.snackbar('', "неверный пароль", colorText: Colors.red);
    }
  }
}
