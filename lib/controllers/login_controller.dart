import 'dart:convert';
import 'dart:developer';

import 'package:dagenergi/api/api.dart';
import 'package:dagenergi/views/login/login_page.dart';
import 'package:dagenergi/views/tasks/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoggedIn = false.obs;
  GetStorage box = GetStorage();
  final uri = ApiUrl.loginUrl;
  final logoutUri = ApiUrl.logoutUrl;

  void login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      Map<String, dynamic> userData = {
        "username": username,
        "password": password
      };
      final response = await http.post(Uri.parse(uri),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData));
      if (response.statusCode == 200) {
        print(response.body);
        box.write('user', userData);
        Get.offAll(() => const TaskPage());
      } else {
        Get.snackbar('😳', 'Пользователь не найден данные введены не корректно',
            colorText: Colors.white, backgroundColor: Colors.red.shade300);
      }
    } else {
      Get.snackbar('', "неверный пароль", colorText: Colors.red);
    }
  }

  void logout() async {
    try {
      final response = await http.post(Uri.parse(logoutUri));
      if (response.statusCode == 200) {
        Get.offAll(() => const LogInPage());
        box.remove('user');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
