import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_job/Utils/app_constants.dart';
import 'package:good_job/models/apply.dart';
import 'package:good_job/models/applying_job.dart';
import 'package:good_job/models/company.dart';
import 'package:good_job/models/degree.dart';
import 'package:good_job/models/district.dart';
import 'package:good_job/models/jobs.dart';
import 'package:good_job/models/major.dart';
import 'package:good_job/models/my_response.dart';
import 'package:good_job/models/position.dart';
import 'package:good_job/models/province.dart';
import 'package:good_job/models/salary.dart';
import 'package:http/http.dart' as http;

class JobController extends GetxController {
  List<Jobs> jobs = <Jobs>[].obs;
  List<Position> positions = <Position>[].obs;
  List<Jobs> jobsTemp = <Jobs>[];
  List<Major> majors = <Major>[].obs;
  List<Degree> degrees = <Degree>[].obs;
  List<Salary> salaries = <Salary>[].obs;
  List<Province> provinces = <Province>[].obs;
  List<District> districts = <District>[].obs;
  List<ApplyingJob> applyingJobs = <ApplyingJob>[].obs;

  final _storage = GetStorage();

  var jobDegree = "".obs;
  var salaryRate = "".obs;
  var major = "".obs;
  var jobFilter = "d.jobName".obs;
  var searchValue = "".obs;

  var applyingDegree = "".obs;

  var province = "".obs;
  var district = "".obs;

  var isAcceptedExists = false.obs;
  var isPendingTab = true.obs;

  var isCompanyLoading = true.obs;
  var company = Company();

  void resetVar() {
    applyingDegree.value = "";
    jobDegree.value = "";
    salaryRate.value = "";
    major.value = "";
    jobFilter.value = "";
    province.value = "";
    district.value = "";
    searchValue.value = "";
    isAcceptedExists.value = false;
    isPendingTab.value = true;
    isAddressLoaded.value = false;
    isCompanyLoading.value = true;
    company = Company();
  }

  var isAddressLoaded = false.obs;

  var isJobsLoading = true.obs;
  var isJobsApplyingLoading = true.obs;

  final randomIndex = [];

  void getRandom() {
    int length = jobs.length > 5 ? 5 : jobs.length;

    while (randomIndex.length < length) {
      int num = Random().nextInt(jobs.length);
      if (!randomIndex.contains(num)) randomIndex.add(num);
    }
  }

  Future<MyResponse> loadCompany(String companyId) async {
    try {
      final response = await http
          .post(
            Uri.http(URL, 'goodjob/api/company.api.php'),
            headers: {
              HttpHeaders.contentTypeHeader: APPLICATION_JSON,
              METHOD: 'getCompany',
              TOKEN: _storage.read(TOKEN),
            },
            body: jsonEncode({"id": companyId}),
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
          );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        company = Company.fromJson(responseDecode['data'][0]);
        isCompanyLoading.value = false;
        print('company: ${responseDecode['data'][0]}');
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> loadMajor() async {
    try {
      final response = await http.get(
        Uri.http(URL, 'goodjob/api/major.api.php'),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'majorListAll',
          TOKEN: _storage.read(TOKEN),
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        majors.clear();
        responseDecode['data'].forEach((json) {
          final major = Major.fromJson(json);
          majors.add(major);
        });
        print('major: $responseDecode');
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> loadPosition() async {
    try {
      final response = await http.get(
        Uri.http(URL, 'goodjob/api/position.api.php'),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'positionListAll',
          TOKEN: _storage.read(TOKEN),
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        positions.clear();
        responseDecode['data'].forEach((json) {
          final position = Position.fromJson(json);
          positions.add(position);
        });
        print('positions: $responseDecode');
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> loadDegree() async {
    try {
      final response = await http.get(
        Uri.http(URL, 'goodjob/api/degree.api.php'),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'degreeListAll',
          TOKEN: _storage.read(TOKEN),
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        print('degree: $responseDecode');
        degrees.clear();
        responseDecode['data'].forEach((json) {
          final degree = Degree.fromJson(json);
          degrees.add(degree);
        });
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> loadSalary() async {
    try {
      final response = await http.get(
        Uri.http(URL, 'goodjob/api/salaryRate.api.php'),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'salaryRateListAll',
          TOKEN: _storage.read(TOKEN),
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        print('salary: $responseDecode');
        salaries.clear();
        responseDecode['data'].forEach((json) {
          final salary = Salary.fromJson(json);
          salaries.add(salary);
        });
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> loadProvince() async {
    try {
      final response = await http.get(
        Uri.http(URL, 'goodjob/api/province.api.php'),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'provinceListAll',
          TOKEN: MY_TOKEN,
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        print('province: $responseDecode');
        provinces.clear();
        responseDecode['data'].forEach((json) {
          final province = Province.fromJson(json);
          provinces.add(province);
        });
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> loadDistrict() async {
    try {
      final response = await http.get(
        Uri.http(URL, 'goodjob/api/district.api.php'),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'districtListAll',
          TOKEN: MY_TOKEN,
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        print('district: $responseDecode');
        districts.clear();
        responseDecode['data'].forEach((json) {
          final district = District.fromJson(json);
          districts.add(district);
        });
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> findAllJob() async {
    try {
      final response = await http.post(
        Uri.http(URL, 'goodjob/api/postJob.api.php'),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'postJobListAll',
          TOKEN: _storage.read(TOKEN),
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        jobs.clear();
        jobsTemp.clear();
        responseDecode['data'].forEach((json) {
          final job = Jobs.fromJson(json);
          jobs.add(job);
          jobsTemp.add(job);
        });
        update(['jobs']);
        isJobsLoading.value = false;

        getRandom();
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> searchJob({String filter, String value}) async {
    try {
      final response = await http
          .post(
            Uri.http(URL, 'goodjob/api/postJob.api.php'),
            headers: {
              HttpHeaders.contentTypeHeader: APPLICATION_JSON,
              METHOD: 'searchJob',
              TOKEN: _storage.read(TOKEN),
            },
            body: jsonEncode({"key": filter ?? jobFilter.value, "value": value}),
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
          );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        jobs.clear();
        responseDecode['data'].forEach((json) {
          final job = Jobs.fromSearch(json);
          // manual load image
          jobsTemp.forEach((element) {
            if (element.id == json['id']) {
              job.image = element.image;
              job.description = element.description;
            }
          });
          jobs.add(job);
        });
        update(['jobs']);
        isJobsLoading.value = false;

        randomIndex.clear();
        getRandom();
      }

      print('response: $responseDecode');

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> applyJob(Apply apply) async {
    try {
      final response = await http
          .post(
            Uri.http(URL, 'goodjob/api/apply.api.php'),
            headers: {
              HttpHeaders.contentTypeHeader: APPLICATION_JSON,
              METHOD: 'addApply',
              TOKEN: _storage.read(TOKEN),
            },
            body: applyToJson(apply),
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
          );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> findAllApplyingJob(Apply apply) async {
    try {
      final response = await http
          .post(
            Uri.http(URL, 'goodjob/api/apply.api.php'),
            headers: {
              HttpHeaders.contentTypeHeader: APPLICATION_JSON,
              METHOD: 'applyListAllByMember',
              TOKEN: _storage.read(TOKEN),
            },
            body: applyToJson(apply),
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
          );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        applyingJobs.clear();
        responseDecode['data'].forEach((json) {
          final applyingJob = ApplyingJob.fromJson(json);
          applyingJobs.add(applyingJob);
        });
        update(['applyingJobs']);
        isJobsApplyingLoading.value = false;
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }
}
