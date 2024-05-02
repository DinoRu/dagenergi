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
  String? comment;

  TaskComplete({
    required this.nearPhotoUrl,
    required this.farPhotoUrl,
    required this.previousIndication,
    required this.currentIndication,
    this.comment,
  });

  factory TaskComplete.fromJson(Map<String, dynamic> json) => TaskComplete(
    nearPhotoUrl: json["near_photo_url"],
    farPhotoUrl: json["far_photo_url"],
    previousIndication: json["previous_indication"],
    currentIndication: json["current_indication"],
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    "near_photo_url": nearPhotoUrl,
    "far_photo_url": farPhotoUrl,
    "previous_indication": previousIndication,
    "current_indication": currentIndication,
    "comment":  comment,
  };
}
