// To parse this JSON data, do
//
//     final degree = degreeFromJson(jsonString);

import 'dart:convert';

Degree degreeFromJson(String str) => Degree.fromJson(json.decode(str));

String degreeToJson(Degree data) => json.encode(data.toJson());

class Degree {
  Degree({
    this.id,
    this.degree,
  });

  String id;
  String degree;

  factory Degree.fromJson(Map<String, dynamic> json) => Degree(
    id: json["id"],
    degree: json["degree"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "degree": degree,
  };
}
