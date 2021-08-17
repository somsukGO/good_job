import 'dart:convert';

Apply applyFromJson(String str) => Apply.fromJson(json.decode(str));

String applyToJson(Apply data) => json.encode(data.toJson());

class Apply {
  Apply({
    this.memberId,
    this.degreeId,
    this.majorId,
    this.postJobDetailId,
    this.applyDescription = "I am interesting this job",
  });

  int memberId;
  int degreeId;
  int majorId;
  int postJobDetailId;
  String applyDescription;

  factory Apply.fromJson(Map<String, dynamic> json) => Apply(
        memberId: json["member_id"],
        degreeId: json["degree_id"],
        majorId: json["major_id"],
        postJobDetailId: json["postJobDetail_id"],
        applyDescription: json["applyDescription"],
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "degree_id": degreeId,
        "major_id": majorId,
        "postJobDetail_id": postJobDetailId,
        "applyDescription": applyDescription,
      };

  @override
  String toString() {
    return 'Apply{memberId: $memberId, degreeId: $degreeId, majorId: $majorId, postJobDetailId: $postJobDetailId, applyDescription: $applyDescription}';
  }
}
