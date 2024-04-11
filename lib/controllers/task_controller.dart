import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dagenergi/models/tasks.dart';
import 'package:dagenergi/utils/upload_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';


String accessKeyId ="YCAJEMEwAsaTkKXVWTbJUUVV3";
String secretAccessKey = "YCMDLUMoKWiYuncBjuRcGF3qiI7KqFx_X08ATffc";
String endpointUrl = "https://storage.yandexcloud.net";
String regionName = "ru-central1";
String bucketName = "2ad";

class TaskController extends GetxController {

  //? TextEditingController
  TextEditingController indicationCtrl = TextEditingController();
  TextEditingController commentCtrl = TextEditingController();
  TextEditingController idCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController implementCtrl = TextEditingController();
  TextEditingController longitudeCtrl = TextEditingController();
  TextEditingController latitudeCtrl = TextEditingController();
  TextEditingController codeCtrl = TextEditingController();


  XFile? _file;
  XFile? _hFile;
  XFile? get hFile => _hFile;
  XFile? get file => _file;

  void setFile(XFile? file) {
    _file = file;
    update();
  }

  void setHFile(XFile? hFile) {
    _hFile = hFile;
    update();
  }

  final _picker = ImagePicker();

  double latitude = 0.0;
  double longitue = 0.0;

  bool isCompleted = false;
  String myPosition = '';
  String meterImageUrl= '';
  String homImageUrl = '';

  List<MyTask> tasks = [];

  //YANDEX AWS

  File? imageFile;

  Future<void> prendrePicture() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      final File image = File(pickedImage.path);
      final String path = await _localPath;
      final String fileName = "${DateTime.now().microsecondsSinceEpoch}.jpg";
      final Directory directory = Directory('$path/images');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      final File newImage = await image.copy('${directory.path}/$fileName');
      imageFile = newImage;
      update();
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }



  Future<void> takeImage(MyTask myTask) async {
    _file = await _picker.pickImage(source: ImageSource.camera);
    if(_file != null) {

      meterImageUrl = await uploadImage(_file!);
      print(meterImageUrl);
      String fileName = _file!.path.split('/').last;
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String newFileName = "${myTask.code}_${currentDate}_forword.jpg";
      await uploadPhotoToYandexStorage(_file!, newFileName);
    }
    update();
  }

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


  Future<void> takeHomeImage(MyTask myTask) async {
    _hFile = await _picker.pickImage(source: ImageSource.camera);
    if(_hFile != null) {
      homImageUrl = await uploadImage(_hFile!);
      print(homImageUrl);
        String fileName = _hFile!.path.split('/').last;
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        String newFileName = "${myTask.code}_${currentDate}_near.jpeg";
        await uploadPhotoToYandexStorage(_file!, newFileName);

      }
    update();
  }

  @override
  void onInit() async {
    await getAllTask();
    super.onInit();
    sendPosition();
  }

  Future<Position> getPosition() async {
    await Geolocator.requestPermission();
    await Geolocator.isLocationServiceEnabled();
    Position? position = await Geolocator.getCurrentPosition();
    return position;
  }

  void sendPosition() {
    try {
      getPosition().then((Position myPos) {
       myPosition = "Latitude: ${myPos.latitude.toString()} - Longitude: ${myPos.longitude.toString()}";
       latitude = myPos.latitude;
       longitue = myPos.longitude;
      });
      update();
    } catch(e) {
      print(e.toString());
    } finally {
      update();
    }
  }

  Future<void> createTask(MyTask newTask) async {
    const apiUrl = 'http://45.147.176.236:5000/tasks/';
    try {

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: taskToJson(newTask),
      );
      if (response.statusCode == 201) {
        print('Task created successfully');
      } else {
        throw Exception('Failed to create task');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      update();
    }
  }

  Future<void> getAllTask() async {
    const apiUrl = "http://45.147.176.236:5000/tasks";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200) {
        final List<Map<String, dynamic>> responseData = List<Map<String, dynamic>>.from(json.decode(response.body)['result']['data']);
        tasks = responseData.map((json) => MyTask.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch tasks');

      }

    } catch(e) {
      log(e.toString());
    }
  }

  Future<void> completeTask(String taskId, MyTask updateTask) async {
    final apiUrl = "http://45.147.176.236:5000/tasks/$taskId/complete";
    try {
      // Upload des images sur Firebase Storage
      String nearPhotoFileName = await uploadImage(hFile!);
      String farPhotoFileName = await uploadImage(file!);
      updateTask.nearPhotoUrl = nearPhotoFileName;
      updateTask.farPhotoUrl = farPhotoFileName;
      final response = await http.put(
          Uri.parse(apiUrl),
          body: json.encode({
            "near_photo_url": nearPhotoFileName,
            "far_photo_url": farPhotoFileName,
            "previous_indication": updateTask.previousIndication?.toDouble(),
            "current_indication": updateTask.currentIndication?.toDouble(),
          }),
      );
      print(response.body);

      if(response.statusCode == 200) {
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