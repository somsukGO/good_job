import 'dart:convert';

Company companyFromJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Company data) => json.encode(data.toJson());

class Company {
  Company({
    this.id = '',
    this.companyName = '',
    this.address = '',
    this.districtId = '',
    this.provinceId = '',
    this.companyPhonenumber = '',
    this.companyEmail = '',
    this.companyContactInfo = '',
    this.coordinatorPhonenumber = '',
    this.password = '',
    this.image = '',
    this.status = '',
    this.isActive = '',
    this.upproveBy = '',
    this.createdAt = '',
    this.province = '',
    this.district = '',
  });

  String id;
  String companyName;
  String address;
  String districtId;
  String provinceId;
  String companyPhonenumber;
  String companyEmail;
  String companyContactInfo;
  String coordinatorPhonenumber;
  String password;
  String image;
  String status;
  String isActive;
  String upproveBy;
  String createdAt;
  String province;
  String district;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        companyName: json["companyName"],
        address: json["address"],
        districtId: json["district_id"],
        provinceId: json["province_id"],
        companyPhonenumber: json["companyPhonenumber"],
        companyEmail: json["companyEmail"],
        companyContactInfo: json["companyContactInfo"],
        coordinatorPhonenumber: json["coordinatorPhonenumber"],
        password: json["password"],
        image: json["image"],
        status: json["status"],
        isActive: json["isActive"],
        upproveBy: json["upproveBy"],
        createdAt: json["created_at"],
        province: json["province"],
        district: json["district"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "companyName": companyName,
        "address": address,
        "district_id": districtId,
        "province_id": provinceId,
        "companyPhonenumber": companyPhonenumber,
        "companyEmail": companyEmail,
        "companyContactInfo": companyContactInfo,
        "coordinatorPhonenumber": coordinatorPhonenumber,
        "password": password,
        "image": image,
        "status": status,
        "isActive": isActive,
        "upproveBy": upproveBy,
        "created_at": createdAt,
        "province": province,
        "district": district,
      };
}
