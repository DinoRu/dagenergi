// To parse this JSON data, do
//
// final taskComplete = taskCompleteFromJson(jsonString);

import 'dart:convert';

TaskComplete taskCompleteFromJson(String str) => TaskComplete.fromJson(json.decode(str));

String taskCompleteToJson(TaskComplete data) => json.encode(data.toJson());

class TaskComplete {
  String nearPhotoUrl;
  String farPhotoUrl;
  double previousIndication;
  double currentIndication;

  TaskComplete({
    required this.nearPhotoUrl,
    required this.farPhotoUrl,
    required this.previousIndication,
    required this.currentIndication,
  });

  factory TaskComplete.fromJson(Map<String, dynamic> json) => TaskComplete(
    nearPhotoUrl: json["near_photo_url"],
    farPhotoUrl: json["far_photo_url"],
    previousIndication: json["previous_indication"],
    currentIndication: json["current_indication"],
  );

  Map<String, dynamic> toJson() => {
    "near_photo_url": nearPhotoUrl,
    "far_photo_url": farPhotoUrl,
    "previous_indication": previousIndication,
    "current_indication": currentIndication,
  };
}
