import 'dart:convert';

Jobs jobsFromJson(String str) => Jobs.fromJson(json.decode(str));

String jobsToJson(Jobs data) => json.encode(data.toJson());

class Jobs {
  Jobs({
    this.id,
    this.companyId,
    this.fileForm,
    this.description,
    this.companyName,
    this.address,
    this.jobDetail,
    this.image,
  });

  String id;
  String companyId;
  String fileForm;
  String description;
  String companyName;
  String address;
  JobDetail jobDetail;
  String image;

  factory Jobs.fromJson(Map<String, dynamic> json) => Jobs(
        id: json["id"] ?? "-",
        companyId: json["company_id"] ?? "-",
        fileForm: json["fileForm"] ?? "-",
        description: json["description"] ?? "This is description",
        companyName: json["companyName"] ?? "Company name",
        address: json["address"] ?? "Laos Vientiane",
        image: json["image"] ?? "",
        jobDetail: json['jobDetail'].length == 0 ? JobDetail() : JobDetail.fromJson(json['jobDetail'][0]),
      );

  factory Jobs.fromSearch(Map<String, dynamic> json) => Jobs(
        id: json["id"] ?? "-",
        companyId: json["company_id"] ?? "-",
        fileForm: json["fileForm"] ?? "-",
        description: json["companyDescription"] ?? "This is company description",
        companyName: json["companyName"] ?? "Company name",
        address: json["address"] ?? "Laos Vientiane",
        image: json["image"] ?? "",
        jobDetail: JobDetail.fromJson({
          "id": json["id"] ?? "0",
          "postJobId": json["postJob_id"] ?? "0",
          "jobName": json["jobName"] ?? "Job name",
          "description": json["description"] ?? "This is job description",
          "posistionId": json["posistion_id"] ?? "0",
          "salaryId": json["salary_id"] ?? "0",
          "degreeId": json["degree_id"] ?? "0",
          "majorId": json["major_id"] ?? "0",
          "status": json["status"] ?? "0",
          "date": json["date"] ?? "-",
          "position": json["position"] ?? "-",
          "salaryRate": json["salaryRate"] ?? "-",
          "degree": json["degree"] ?? "-",
          "major": json["major"] ?? "-",
        }),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "fileForm": fileForm,
        "description": description,
        "companyName": companyName,
        "address": address,
        "jobDetail": null,
      };

  @override
  String toString() {
    return 'Jobs{id: $id, companyId: $companyId, fileForm: $fileForm, description: $description, companyName: $companyName, address: $address, jobDetail: $jobDetail}';
  }
}

class JobDetail {
  JobDetail({
    this.id = '',
    this.postJobId = '',
    this.jobName = '',
    this.description = '',
    this.posistionId = '',
    this.salaryId = '',
    this.degreeId = '',
    this.majorId = '',
    this.status = '',
    this.date = '2021-08-14 12:48:42',
    this.position = '',
    this.salaryRate = '',
    this.degree = '',
    this.major = '',
  });

  String id;
  String postJobId;
  String jobName;
  String description;
  String posistionId;
  String salaryId;
  String degreeId;
  String majorId;
  dynamic status;
  String date;
  String position;
  String salaryRate;
  String degree;
  String major;

  factory JobDetail.fromJson(Map<String, dynamic> json) => JobDetail(
        id: json["id"] ?? "0",
        postJobId: json["postJob_id"] ?? "0",
        jobName: json["jobName"] ?? "Job name",
        description: json["description"] ?? "This is description",
        posistionId: json["posistion_id"] ?? "0",
        salaryId: json["salary_id"] ?? "0",
        degreeId: json["degree_id"] ?? "0",
        majorId: json["major_id"] ?? "0",
        status: json["status"] ?? "0",
        date: json["date"] ?? "-",
        position: json["position"] ?? "-",
        salaryRate: json["salaryRate"] ?? "-",
        degree: json["degree"] ?? "-",
        major: json["major"] ?? "-",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postJob_id": postJobId,
        "jobName": jobName,
        "description": description,
        "posistion_id": posistionId,
        "salary_id": salaryId,
        "degree_id": degreeId,
        "major_id": majorId,
        "status": status,
        "date": date,
        "position": position,
        "salaryRate": salaryRate,
        "degree": degree,
        "major": major,
      };

  @override
  String toString() {
    return 'JobDetail{id: $id, postJobId: $postJobId, jobName: $jobName, description: $description, posistionId: $posistionId, salaryId: $salaryId, degreeId: $degreeId, majorId: $majorId, status: $status, date: $date, position: $position, salaryRate: $salaryRate, degree: $degree, major: $major}';
  }
}
