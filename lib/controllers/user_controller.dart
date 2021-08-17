import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_job/Utils/app_constants.dart';
import 'package:good_job/models/my_response.dart';
import 'package:good_job/models/users.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  var user = Users().obs;
  final _storage = GetStorage();
  var fromLogin = true.obs;
  var fromLogout = false.obs;

  Future<MyResponse> register(Users userDto) async {
    try {
      final response = await http.post(
        Uri.http(URL, 'goodjob/api/member.api.php'),
        body: usersToJson(userDto),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'addMember',
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        return login(userDto);
      }

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> login(Users userDto) async {
    try {
      final response = await http.post(
        Uri.http(URL, 'goodjob/api/loginMember.api.php'),
        body: usersToJson(userDto),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        user.value = Users.fromJson(responseDecode[DATA]);
        _storage.write(TOKEN, responseDecode['Token']);
        _storage.write(USER_ID, int.parse(responseDecode[DATA]['id']));
      }

      print(responseDecode);

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> getMember() async {
    try {
      final response = await http.post(
        Uri.http(URL, 'goodjob/api/member.api.php'),
        body: jsonEncode({"id": _storage.read(USER_ID)}),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'getMember',
          TOKEN: _storage.read(TOKEN),
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
        user.value = Users.fromJson(responseDecode[DATA][0]);
      }

      print('getMember: $responseDecode');

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> changePassword(String newPassword) async {
    try {
      final response = await http.post(
        Uri.http(URL, 'goodjob/api/member.api.php'),
        body: jsonEncode({"id": int.parse(user.value.id), "newPassword": newPassword}),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'changePassword',
          TOKEN: _storage.read(TOKEN),
        },
      ).timeout(
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

  Future<MyResponse> updateProfile(Users userDto) async {
    try {
      final response = await http.post(
        Uri.http(URL, 'goodjob/api/member.api.php'),
        body: usersToJson(userDto),
        headers: {
          HttpHeaders.contentTypeHeader: APPLICATION_JSON,
          METHOD: 'updateMember',
          TOKEN: _storage.read(TOKEN),
        },
      ).timeout(
        Duration(seconds: 60),
        onTimeout: () => http.Response('The connection has timed out, Please try again!', 408),
      );

      if (response.statusCode == 408) return MyResponse(status: '408', message: response.body);

      final responseDecode = jsonDecode(response.body);

      if (responseDecode[STATUS] == SUCCESS) {
          getMember();
      }

      print('test: $responseDecode');

      return MyResponse.fromJson(responseDecode);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }

  Future<MyResponse> logout() async {
    try {
      _storage.remove(TOKEN);
      _storage.remove(USER_ID);
      user.value = Users();
      fromLogin.value = true;
      return MyResponse(status: '1', message: 'logoutSuccess'.tr);
    } catch (err) {
      print(err);
      return MyResponse(status: '400', message: err.toString());
    }
  }
}
