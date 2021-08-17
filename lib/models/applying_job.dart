import 'dart:convert';

ApplyingJob applyingJobFromJson(String str) => ApplyingJob.fromJson(json.decode(str));

String applyingJobToJson(ApplyingJob data) => json.encode(data.toJson());

class ApplyingJob {
  ApplyingJob({
    this.id,
    this.memberId,
    this.degreeId,
    this.majorId,
    this.postJobDetailId,
    this.applyDate,
    this.applyDescription,
    this.status,
    this.acceptBy,
    this.acceptDate,
    this.acceptDescription,
    this.interviewDate,
    this.memberName,
    this.memberLastname,
    this.gender,
    this.memberPhonenumber,
    this.memberAddress,
    this.degree,
    this.major,
    this.jobName,
    this.jobDescription,
    this.companyName,
    this.companyAddress,
    this.companyImage,
  });

  String id;
  String memberId;
  String degreeId;
  String majorId;
  String postJobDetailId;
  String applyDate;
  String applyDescription;
  String status;
  dynamic acceptBy;
  dynamic acceptDate;
  dynamic acceptDescription;
  dynamic interviewDate;
  String memberName;
  String memberLastname;
  String gender;
  String memberPhonenumber;
  String memberAddress;
  String degree;
  String major;
  String jobName;
  String jobDescription;
  String companyName;
  String companyAddress;
  String companyImage;

  factory ApplyingJob.fromJson(Map<String, dynamic> json) => ApplyingJob(
        id: json["id"] ?? "-",
        memberId: json["member_id"] ?? "-",
        degreeId: json["degree_id"] ?? "-",
        majorId: json["major_id"] ?? "-",
        postJobDetailId: json["postJobDetail_id"] ?? "-",
        applyDate: json["applyDate"] ?? "-",
        applyDescription: json["applyDescription"] ?? "-",
        status: json["status"] ?? "-",
        acceptBy: json["acceptBy"] ?? "-",
        acceptDate: json["acceptDate"] ?? "-",
        acceptDescription: json["acceptDescription"] ?? "-",
        interviewDate: json["interviewDate"] ?? "-",
        memberName: json["memberName"] ?? "-",
        memberLastname: json["memberLastname"] ?? "-",
        gender: json["gender"] ?? "-",
        memberPhonenumber: json["memberPhonenumber"] ?? "-",
        memberAddress: json["memberAddress"] ?? "-",
        degree: json["degree"] ?? "-",
        major: json["major"] ?? "-",
        jobName: json["jobName"] ?? "-",
        jobDescription: json["jobDescription"] ?? "-",
        companyName: json["companyName"] ?? "-",
        companyAddress: json["companyAddress"] ?? "-",
        companyImage: json["companyImage"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "member_id": memberId,
        "degree_id": degreeId,
        "major_id": majorId,
        "postJobDetail_id": postJobDetailId,
        "applyDate": applyDate,
        "applyDescription": applyDescription,
        "status": status,
        "acceptBy": acceptBy,
        "acceptDate": acceptDate,
        "acceptDescription": acceptDescription,
        "interviewDate": interviewDate,
        "memberName": memberName,
        "memberLastname": memberLastname,
        "gender": gender,
        "memberPhonenumber": memberPhonenumber,
        "memberAddress": memberAddress,
        "degree": degree,
        "major": major,
        "jobName": jobName,
        "jobDescription": jobDescription,
        "companyName": companyName,
        "companyAddress": companyAddress,
        "companyImage": companyImage,
      };

  @override
  String toString() {
    return 'ApplyingJob{id: $id, memberId: $memberId, degreeId: $degreeId, majorId: $majorId, postJobDetailId: $postJobDetailId, applyDate: $applyDate, applyDescription: $applyDescription, status: $status, acceptBy: $acceptBy, acceptDate: $acceptDate, acceptDescription: $acceptDescription, interviewDate: $interviewDate, memberName: $memberName, memberLastname: $memberLastname, gender: $gender, memberPhonenumber: $memberPhonenumber, memberAddress: $memberAddress, degree: $degree, major: $major, jobName: $jobName, jobDescription: $jobDescription, companyName: $companyName, companyAddress: $companyAddress, companyImage: $companyImage}';
  }
}
