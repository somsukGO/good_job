import 'dart:convert';

MyResponse myResponseFromJson(String str) => MyResponse.fromJson(json.decode(str));

String myResponseToJson(MyResponse data) => json.encode(data.toJson());

class MyResponse {
  MyResponse({
    this.status = '0',
    this.message = 'Something went wrong, please try again later',
  });

  String status;
  String message;

  factory MyResponse.fromJson(Map<String, dynamic> json) => MyResponse(
        status: json["status"] ?? '0',
        message: json["message"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };

  @override
  String toString() {
    return 'MyResponse{status: $status, message: $message}';
  }
}
