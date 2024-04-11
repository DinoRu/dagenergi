import 'package:dagenergi/components/my_button.dart';
import 'package:dagenergi/components/my_textfield.dart';
import 'package:dagenergi/controllers/task_controller.dart';
import 'package:dagenergi/models/tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Выполнить задач'),
        ),
        // body: SafeArea(
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         MyTextfield(title: "id", controller: ctrl.idCtrl),
        //         MyTextfield(title: "code", controller: ctrl.codeCtrl,),
        //         MyTextfield(title: "name", controller: ctrl.nameCtrl),
        //         MyTextfield(title: "address", controller: ctrl.addressCtrl),
        //         MyTextfield(title: "currentIndex", controller: ctrl.indicationCtrl,),
        //         MyTextfield(title: "implementer", controller: ctrl.implementCtrl),
        //         MyTextfield(title: "latitude", controller: ctrl.latitudeCtrl,),
        //         MyTextfield(title: 'longitude', controller: ctrl.longitudeCtrl,),
        //         MyTextfield(title: 'comment', controller: ctrl.commentCtrl),
        //         GestureDetector(
        //           onTap: () {
        //             final newTask = Task(
        //                 taskId: ctrl.idCtrl.text,
        //                 code: ctrl.codeCtrl.text,
        //                 name: ctrl.nameCtrl.text,
        //                 address: ctrl.addressCtrl.text,
        //                 currentIndication: int.parse(ctrl.indicationCtrl.text),
        //                 implementer: ctrl.implementCtrl.text,
        //                 latitude: int.parse(ctrl.latitudeCtrl.text),
        //                 longitude: int.parse(ctrl.longitudeCtrl.text),
        //                 comment: ctrl.commentCtrl.text,
        //             );
        //
        //             ctrl.createTask(newTask);
        //             Navigator.pop(context);
        //           },
        //           child: const MyButton(
        //           ),
        //         ),
        //         const SizedBox(height: 20),
        //       ],
        //     ),
        //   ),
        // ),
      );
    });
  }
}
