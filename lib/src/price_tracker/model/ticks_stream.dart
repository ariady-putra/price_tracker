import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'error.dart';

part 'ticks_stream.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class Tick {
  String id; // "d1ee7d0d-3ca9-fbb4-720b-5312d487185b"
  String symbol; // "R_50"
  double pipSize; // 5.0
  int epoch; // 1234567890
  double quote; // 1.47
  double bid; // 0.36
  double ask; // 2.58

  Tick({
    required this.id,
    required this.symbol,
    required this.pipSize,
    required this.epoch,
    required this.quote,
    required this.bid,
    required this.ask,
  });

  factory Tick.fromJson(Map<String, dynamic> json) => _$TickFromJson(json);

  Map<String, dynamic> toJson() => _$TickToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
/*
  {
    "ticks": "R_50",
    "subscribe": 1
  }
*/
class TicksStreamRequest {
  String ticks;
  int? subscribe;

  TicksStreamRequest({
    required this.ticks,
    this.subscribe,
    this.passthrough,
    this.reqId,
  });

  Object? passthrough;
  int? reqId;

  factory TicksStreamRequest.fromJson(Map<String, dynamic> json) =>
      _$TicksStreamRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TicksStreamRequestToJson(this);

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
      "subscribe": 1,
      "ticks": "R_50"
    },
    "msg_type": "tick",
    "subscription": {
      "id": "d1ee7d0d-3ca9-fbb4-720b-5312d487185b"
    },
    "tick": {
      "ask": 2.58,
      "bid": 0.36,
      "epoch": 1234567890,
      "id": "d1ee7d0d-3ca9-fbb4-720b-5312d487185b",
      "pip_size": 5.0,
      "quote": 1.47,
      "symbol": "R_50"
    }
  }
*/
class TicksStreamResponse {
  TickSubscription? subscription;
  Tick? tick;

  TicksStreamResponse({
    required this.subscription,
    required this.tick,
    required this.echoReq,
    required this.msgType,
    this.reqId,
    this.error,
  });

  TicksStreamRequest echoReq;
  String msgType;

  int? reqId;

  ResponseError? error;

  factory TicksStreamResponse.fromJson(Map<String, dynamic> json) =>
      _$TicksStreamResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TicksStreamResponseToJson(this);

  factory TicksStreamResponse.jsonDecode(String source) =>
      TicksStreamResponse.fromJson(
        json.decode(source),
      );
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
/*
  {
    "id": "d1ee7d0d-3ca9-fbb4-720b-5312d487185b"
  }
*/
class TickSubscription {
  String id;

  TickSubscription({required this.id});

  factory TickSubscription.fromJson(Map<String, dynamic> json) =>
      _$TickSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$TickSubscriptionToJson(this);
}
