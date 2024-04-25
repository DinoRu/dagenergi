import 'package:flutter/material.dart';

import '../../custom_widgets/my_drawer.dart';

class CompleteTaskPage extends StatelessWidget {
  const CompleteTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Задача завершена'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications)
          ),
        ],

      ),
      drawer: const MyDrawer(),
      
    );
  }
}
