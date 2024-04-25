import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

String accessKeyId ="YCAJEMEwAsaTkKXVWTbJUUVV3";
String secretAccessKey = "YCMDLUMoKWiYuncBjuRcGF3qiI7KqFx_X08ATffc";
String endpointUrl = "https://storage.yandexcloud.net";
String regionName = "ru-central1";
String bucketName = "2ad";





Future<void> uploadPhotoToYandexStorage(XFile image, String fileName) async {
  String uploadUrl = '$endpointUrl/$bucketName/$fileName';
  try {
    var request = http.MultipartRequest('PUT', Uri.parse(uploadUrl));
    var file = File(image.path).readAsBytesSync();
    request.files.add(http.MultipartFile.fromBytes('file', file, filename: fileName));
    request.fields.addAll({'key': fileName, 'acl': 'public-read'});
    request.headers['Authorization'] = 'Basic ${base64Encode(utf8.encode('$accessKeyId:$secretAccessKey'))}';

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image uploaded successfully!");
    } else {
      print("Failed to upload image. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print('Failed to upload image. Error: $e');
  }
}

