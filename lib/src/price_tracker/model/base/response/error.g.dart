// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseError _$ResponseErrorFromJson(Map<String, dynamic> json) =>
    ResponseError(
      code: json['code'] as String?,
      details: json['details'] == null
          ? null
          : ResponseErrorDetails.fromJson(
              json['details'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ResponseErrorToJson(ResponseError instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('details', instance.details?.toJson());
  writeNotNull('message', instance.message);
  return val;
}

ResponseErrorDetails _$ResponseErrorDetailsFromJson(
        Map<String, dynamic> json) =>
    ResponseErrorDetails(
      field: json['field'] as String?,
    );

Map<String, dynamic> _$ResponseErrorDetailsToJson(
    ResponseErrorDetails instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('field', instance.field);
  return val;
}
