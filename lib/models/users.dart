import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    this.id,
    this.memberName = '-',
    this.memberLastname = '-',
    this.memberAddress = '-',
    this.districtId = '1',
    this.provinceId = '1',
    this.gender = '-',
    this.dob = '2000-01-01',
    this.phonenumber,
    this.password,
    this.email = '-',
    this.image = "",
  });

  String id;
  String memberName;
  String memberLastname;
  String memberAddress;
  String districtId;
  String provinceId;
  String gender;
  String dob;
  String phonenumber;
  String password;
  String email;
  String image;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"] ?? "0",
        memberName: json["memberName"] ?? "-",
        memberLastname: json["memberLastname"] ?? "-",
        memberAddress: json["memberAddress"] ?? "-",
        districtId: json["district_id"] ?? "1",
        provinceId: json["province_id"] ?? "1",
        gender: json["gender"] ?? "-",
        dob: json["dob"] ?? "-",
        phonenumber: json["phonenumber"] ?? "-",
        password: json["password"] ?? "-",
        email: json["email"] ?? "-",
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "memberName": memberName,
        "memberLastname": memberLastname,
        "memberAddress": memberAddress,
        "district_id": districtId,
        "province_id": provinceId,
        "gender": gender,
        "dob": dob,
        "phonenumber": phonenumber,
        "password": password,
        "email": email,
        "image": image,
      };

  @override
  String toString() {
    return 'Users{id: $id, memberName: $memberName, memberLastname: $memberLastname, memberAddress: $memberAddress, districtId: $districtId, provinceId: $provinceId, gender: $gender, dob: $dob, phonenumber: $phonenumber, password: $password, email: $email}';
  }
}
