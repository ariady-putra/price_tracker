// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgetRequest _$ForgetRequestFromJson(Map<String, dynamic> json) =>
    ForgetRequest(
      forget: json['forget'] as String,
      passthrough: json['passthrough'],
      reqId: json['req_id'] as int?,
    );

Map<String, dynamic> _$ForgetRequestToJson(ForgetRequest instance) {
  final val = <String, dynamic>{
    'forget': instance.forget,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('passthrough', instance.passthrough);
  writeNotNull('req_id', instance.reqId);
  return val;
}

ForgetResponse _$ForgetResponseFromJson(Map<String, dynamic> json) =>
    ForgetResponse(
      forget: json['forget'] as int,
      echoReq: ForgetRequest.fromJson(json['echo_req'] as Map<String, dynamic>),
      msgType: json['msg_type'] as String,
      reqId: json['req_id'] as int?,
    );

Map<String, dynamic> _$ForgetResponseToJson(ForgetResponse instance) {
  final val = <String, dynamic>{
    'forget': instance.forget,
    'echo_req': instance.echoReq.toJson(),
    'msg_type': instance.msgType,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('req_id', instance.reqId);
  return val;
}
