import 'package:dagenergi/views/home/homepage.dart';
import 'package:dagenergi/views/login/login_page.dart';
import 'package:dagenergi/views/tasks/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      Get.off(const LogInPage());
    });
  }

}
