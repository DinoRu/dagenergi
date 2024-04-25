import 'package:dagenergi/controllers/splash_controller.dart';
import 'package:dagenergi/controllers/task_controller.dart';
import 'package:dagenergi/views/splash/splash_page.dart';
import 'package:dagenergi/views/tasks/tasks_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  Get.put(TaskController());
  Get.put(SplashController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      title: 'dagenergi',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade100,
          primary: Colors.blue,
        )
      ),

      home: const SplashPage(),
      routes: {
        "tasks": (context) => const TaskPage(),
        // "task_detail": (context) => const TaskDetailPage(),
      },
    );
  }
}
