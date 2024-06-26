import 'package:dagenergi/controllers/login_controller.dart';
import 'package:dagenergi/custom_widgets/my_drawer_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController ctrl = Get.find<LoginController>();
    return Drawer(
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Image.asset('assets/images/home_logo.png', width: 200),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Divider(color: Colors.grey.shade400),
          ),
          MyDrawerTitle(
              text: "Г л а в н а я",
              icon: Icons.home,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'tasks', (route) => false);
              }),
          // MyDrawerTitle(
          //     text: 'И с т о р и я', icon: Icons.history, onTap: () {}),
          MyDrawerTitle(
              text: 'Н а с т р о й к и', icon: Icons.settings, onTap: () {}),
          const Spacer(),
          MyDrawerTitle(
              text: 'В ы х о д',
              icon: Icons.logout,
              onTap: () {
                ctrl.logout();
              }),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
