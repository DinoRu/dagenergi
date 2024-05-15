

import 'package:dagenergi/views/tasks/tasks_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoggedIn = false.obs;

  void login() {
    String username = usernameController.text;
    String password = passwordController.text;

    if(username == 'admin' && password == 'admin') {
      isLoggedIn.value = true;
      Get.offAll(const TaskPage());
    } else {
      Get.snackbar('', "неверный пароль", colorText: Colors.red);
    }

  }
}