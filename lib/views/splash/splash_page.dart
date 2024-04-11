import 'package:dagenergi/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (ctrl) {
      return Scaffold(
        body: Center(
          child: Image.asset('assets/images/home_logo.png'),
        ),
      );
    });
  }
}
