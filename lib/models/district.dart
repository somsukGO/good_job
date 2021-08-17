import 'dart:convert';

District districtFromJson(String str) => District.fromJson(json.decode(str));

String districtToJson(District data) => json.encode(data.toJson());

class District {
  District({
    this.districtId,
    this.district,
    this.provinceId,
    this.province,
  });

  String districtId;
  String district;
  String provinceId;
  String province;

  factory District.fromJson(Map<String, dynamic> json) => District(
    districtId: json["district_id"],
    district: json["district"],
    provinceId: json["province_id"],
    province: json["province"],
  );

  Map<String, dynamic> toJson() => {
    "district_id": districtId,
    "district": district,
    "province_id": provinceId,
    "province": province,
  };
}