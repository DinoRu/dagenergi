import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;


class YandexStorageExample extends StatefulWidget {
  const YandexStorageExample({super.key});

  @override
  _YandexStorageExampleState createState() => _YandexStorageExampleState();
}

class _YandexStorageExampleState extends State<YandexStorageExample> {
  final String apiKey = 'YCAJEzExiV55ARCpSqLAdhBW5';
  final String bucketName = 'tooaccouting';
  final String yandexStorageEndpoint = 'https://storage.yandexcloud.net';

  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<void> uploadPhoto(File photo) async {
    try {
      final String fileName = path.basename(photo.path);
      final Uri uploadUrl = Uri.parse('$yandexStorageEndpoint/$bucketName/$fileName');

      final response = await http.put(
        uploadUrl,
        headers: {
          'Content-Type': 'image/jpeg', // Change the content type based on your photo type
          'Authorization': 'Bearer $apiKey',
        },
        body: await photo.readAsBytes(),
      );

      if (response.statusCode == 201) {
        print('Photo uploaded successfully.');
      } else {
        print('Failed to upload photo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              File? pickedImage = await pickImage();
      
              if (pickedImage != null) {
                await uploadPhoto(pickedImage);
              }
            } catch (e) {
              print('Error: $e');
            }
          },
          child: Text('Take and Upload Photo'),
        ),
      ),
    );
  }
}
