// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_all.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgetAllRequest _$ForgetAllRequestFromJson(Map<String, dynamic> json) =>
    ForgetAllRequest(
      forgetAll: (json['forget_all'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      passthrough: json['passthrough'],
      reqId: json['req_id'] as int?,
    );

Map<String, dynamic> _$ForgetAllRequestToJson(ForgetAllRequest instance) {
  final val = <String, dynamic>{
    'forget_all': instance.forgetAll,
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

ForgetAllResponse _$ForgetAllResponseFromJson(Map<String, dynamic> json) =>
    ForgetAllResponse(
      forgetAll: (json['forget_all'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      echoReq:
          ForgetAllRequest.fromJson(json['echo_req'] as Map<String, dynamic>),
      msgType: json['msg_type'] as String,
      reqId: json['req_id'] as int?,
      error: json['error'] == null
          ? null
          : ResponseError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ForgetAllResponseToJson(ForgetAllResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('forget_all', instance.forgetAll);
  val['echo_req'] = instance.echoReq.toJson();
  val['msg_type'] = instance.msgType;
  writeNotNull('req_id', instance.reqId);
  writeNotNull('error', instance.error?.toJson());
  return val;
}
