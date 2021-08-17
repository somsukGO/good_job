// To parse this JSON data, do
//
//     final position = positionFromJson(jsonString);

import 'dart:convert';

Position positionFromJson(String str) => Position.fromJson(json.decode(str));

String positionToJson(Position data) => json.encode(data.toJson());

class Position {
  Position({
    this.id,
    this.position,
  });

  String id;
  String position;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    id: json["id"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "position": position,
  };
}
