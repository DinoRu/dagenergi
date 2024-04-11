import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  const MyTextfield({super.key, required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        keyboardType: title == 'currentIndex' || title == 'latitude' || title == 'longitude'? TextInputType.number: TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
          hintText: title,
        ),
      ),
    );
  }
}
