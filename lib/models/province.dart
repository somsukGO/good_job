import 'dart:convert';

Province provinceFromJson(String str) => Province.fromJson(json.decode(str));

String provinceToJson(Province data) => json.encode(data.toJson());

class Province {
  Province({
    this.id,
    this.province,
  });

  String id;
  String province;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    id: json["id"],
    province: json["province"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "province": province,
  };
}