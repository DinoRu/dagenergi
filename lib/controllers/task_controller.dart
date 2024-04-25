import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dagenergi/models/complete_task.dart';
import 'package:dagenergi/models/tasks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class TaskController extends GetxController {

  //? TextEditingController
  TextEditingController commentCtrl = TextEditingController();
  TextEditingController searchItem = TextEditingController();
  final currentIndication = ''.obs;

  void updateIndication(String value) {
    currentIndication.value = value;
  }

  bool loadingImage = false;

  XFile? _file;
  XFile? _hFile;
  XFile? get hFile => _hFile;
  XFile? get file => _file;

  //File setter
  void setFile(XFile? file) {
    _file = file;
    update();
  }

  void setHFile(XFile? hFile) {
    _hFile = hFile;
    update();
  }

   int index = 0;

  void changeIndex(int value) {
    index = value;
    update();
  }

  //Instance of image_picker
  final _picker = ImagePicker();

  //Variables
  bool isCompleted = false;
  String meterImageUrl= '';
  String homeImageUrl = '';

  List<MyTask> tasks = [];

  File? imageFile;

  //Function to take first image
  Future<void> takeImage(MyTask myTask) async {
    _file = await _picker.pickImage(source: ImageSource.camera);
    update();
  }

  //Function to upload image on Firebase Storage
  Future<String> uploadImage(XFile image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = storage.ref('Images').child(fileName);

      UploadTask uploadTask = ref.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      if (taskSnapshot.state == TaskState.success) {
        String downloadUrl = await ref.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  //Function to take second image
  Future<void> takeHomeImage(MyTask myTask) async {
    _hFile = await _picker.pickImage(source: ImageSource.camera);
    update();
  }


  Future<void> uploadImageAndCompleteTask(String taskId, double previousIndication) async {
    try {
      if(_file != null) {
        meterImageUrl = await uploadImage(_file!);
      }
      if(_hFile != null) {
        homeImageUrl = await uploadImage(_hFile!);
      }
      await completeTask(taskId, previousIndication);
    } catch(e) {
      log(e.toString());
    }
  }



  @override
  void onInit() async {
    await getAllTask();
    super.onInit();
  }

  //Function to get all tasks
  Future<void> getAllTask({String? searchItem}) async {
    const apiUrl = "http://45.147.176.236:5000/tasks";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200) {
        final List<Map<String, dynamic>> responseData = List<Map<String, dynamic>>.from(json.decode(response.body)['result']['data']);
        //Filter task by search item
        if(searchItem != null && searchItem.isNotEmpty) {
          tasks = responseData
              .map((json) => MyTask.fromJson(json))
              .where((task) => 
              task.code.contains(searchItem) ||
              task.name.contains(searchItem) ||
              task.address.contains(searchItem)
          ).toList();
        } else {
          tasks = responseData.map((json) => MyTask.fromJson(json)).toList();
        }
      } else {
        throw Exception('Failed to fetch tasks');

      }

    } catch(e) {
      log(e.toString());
    } finally {
      update();
    }
  }

  //Function to update task
  Future<void> completeTask(String taskId, double previousIndication) async{
    final apiUrl = "http://45.147.176.236:5000/tasks/$taskId/complete";
    final completeTask = TaskComplete(
        nearPhotoUrl: meterImageUrl,
        farPhotoUrl: homeImageUrl,
        previousIndication: previousIndication.toDouble(),
        currentIndication: double.parse(currentIndication.value)
      );
    try {
      final response = await http.put(
          Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: taskCompleteToJson(completeTask),
      );
      print(response.body);

      if(response.statusCode == 200) {
        tasks.removeWhere((task) => task.taskId == taskId);
        update();
        Get.snackbar('Success', "Task was updated successufully!", colorText: Colors.green);
      } else {
        print(response.statusCode);
        Get.snackbar('Error', "Failed to update task", colorText: Colors.red);
      }

    } catch(e) {
      Get.snackbar('Failed', "Failed to update!", colorText: Colors.red);
      throw Exception("Failed to updated");
    }


  }

}