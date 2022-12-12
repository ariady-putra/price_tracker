import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
/*
  {
    "code": "ErrorCode",
    "details": {
      "field": "field"
    },
    "message": "Error message."
  },
*/
class ResponseError {
  String? code;
  ResponseErrorDetails? details;
  String? message;

  ResponseError({
    this.code,
    this.details,
    this.message,
  });

  factory ResponseError.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseErrorToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
/*
  {
    "field": "field"
  }
*/
class ResponseErrorDetails {
  String? field;

  ResponseErrorDetails({this.field});

  factory ResponseErrorDetails.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseErrorDetailsToJson(this);
}
