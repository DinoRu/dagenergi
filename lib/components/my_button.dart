import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15)
      ),
      child: const Center(child: Text('Create', style: TextStyle(color: Colors.white, fontSize: 18),)),
    );
  }
}
