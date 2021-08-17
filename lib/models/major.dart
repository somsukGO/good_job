// To parse this JSON data, do
//
//     final major = majorFromJson(jsonString);

import 'dart:convert';

Major majorFromJson(String str) => Major.fromJson(json.decode(str));

String majorToJson(Major data) => json.encode(data.toJson());

class Major {
  Major({
    this.id,
    this.major,
  });

  String id;
  String major;

  factory Major.fromJson(Map<String, dynamic> json) => Major(
        id: json["id"],
        major: json["major"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "major": major,
      };

  @override
  String toString() {
    return 'Major{id: $id, major: $major}';
  }
}
