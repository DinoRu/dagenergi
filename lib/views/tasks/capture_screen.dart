import 'package:dagenergi/controllers/task_controller.dart';
import 'package:dagenergi/models/tasks.dart';
import 'package:flutter/material.dart';

class CapturePhotoPage extends StatefulWidget {
  final MyTask task;
  const CapturePhotoPage({super.key, required this.task});

  @override
  State<CapturePhotoPage> createState() => _CapturePhotoPageState();
}

class _CapturePhotoPageState extends State<CapturePhotoPage> {

  late TaskController ctrl;

  @override
  void initState() {
    ctrl = TaskController.to;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('сфотографировать'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  await ctrl.takeImage(widget.task);
                },
                child: const Text('сфотографировать')
            )
          ],
        ),
      ),
    );
  }
}
