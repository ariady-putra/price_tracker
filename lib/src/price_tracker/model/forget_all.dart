import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base/base.dart';

part 'forget_all.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
/*
  {
    "forget_all": "ticks"
  }
*/
class ForgetAllRequest implements Request {
  List<String> forgetAll;

  ForgetAllRequest({
    required this.forgetAll,
    this.passthrough,
    this.reqId,
  });

  ForgetAllRequest.ticks({
    this.passthrough,
    this.reqId,
  }) : forgetAll = ['ticks'];

  ForgetAllRequest.candles({
    this.passthrough,
    this.reqId,
  }) : forgetAll = ['candles'];

  Object? passthrough;
  int? reqId;

  factory ForgetAllRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgetAllRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetAllRequestToJson(this);

  @override
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
      "forget_all": "ticks",
      "req_id": 1
    },
    "forget_all": [],
    "msg_type": "forget_all",
    "req_id": 1
  }
*/
class ForgetAllResponse implements Response {
  List<String> forgetAll; // IDs of the cancelled streams

  ForgetAllResponse({
    required this.forgetAll,
    required this.echoReq,
    required this.msgType,
    this.reqId,
  });

  ForgetAllRequest echoReq;
  String msgType;

  int? reqId;

  factory ForgetAllResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetAllResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetAllResponseToJson(this);

  @override
  jsonDecode(String source) => ForgetAllResponse.fromJson(
        json.decode(source),
      );
}
