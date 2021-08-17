// To parse this JSON data, do
//
//     final salary = salaryFromJson(jsonString);

import 'dart:convert';

Salary salaryFromJson(String str) => Salary.fromJson(json.decode(str));

String salaryToJson(Salary data) => json.encode(data.toJson());

class Salary {
  Salary({
    this.id,
    this.salaryRate,
  });

  String id;
  String salaryRate;

  factory Salary.fromJson(Map<String, dynamic> json) => Salary(
    id: json["id"],
    salaryRate: json["salaryRate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "salaryRate": salaryRate,
  };
}
