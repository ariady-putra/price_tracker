import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'error.dart';

part 'forget.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
/*
  {
    "forget": "d1ee7d0d-3ca9-fbb4-720b-5312d487185b"
  }
*/
class ForgetRequest {
  String forget;

  ForgetRequest({
    required this.forget,
    this.passthrough,
    this.reqId,
  });

  Object? passthrough;
  int? reqId;

  factory ForgetRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgetRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetRequestToJson(this);

  String jsonEncode() => json.encode(
        toJson(),
      );
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
/*
  {
    "echo_req": {
      "forget": "d1ee7d0d-3ca9-fbb4-720b-5312d487185b",
      "req_id": 1
    },
    "forget": 0,
    "msg_type": "forget",
    "req_id": 1
  }
*/
class ForgetResponse {
  int? forget;

  ForgetResponse({
    required this.forget,
    required this.echoReq,
    required this.msgType,
    this.reqId,
    this.error,
  });

  ForgetRequest echoReq;
  String msgType;

  int? reqId;

  ResponseError? error;

  factory ForgetResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetResponseToJson(this);

  factory ForgetResponse.jsonDecode(String source) => ForgetResponse.fromJson(
        json.decode(source),
      );
}
