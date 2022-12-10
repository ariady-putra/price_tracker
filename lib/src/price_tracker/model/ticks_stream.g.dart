// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticks_stream.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tick _$TickFromJson(Map<String, dynamic> json) => Tick(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      pipSize: (json['pip_size'] as num).toDouble(),
      epoch: json['epoch'] as int,
      quote: (json['quote'] as num).toDouble(),
      bid: (json['bid'] as num).toDouble(),
      ask: (json['ask'] as num).toDouble(),
    );

Map<String, dynamic> _$TickToJson(Tick instance) => <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'pip_size': instance.pipSize,
      'epoch': instance.epoch,
      'quote': instance.quote,
      'bid': instance.bid,
      'ask': instance.ask,
    };

TicksStreamRequest _$TicksStreamRequestFromJson(Map<String, dynamic> json) =>
    TicksStreamRequest(
      ticks: json['ticks'] as String,
      subscribe: json['subscribe'] as int?,
      passthrough: json['passthrough'],
      reqId: json['req_id'] as int?,
    );

Map<String, dynamic> _$TicksStreamRequestToJson(TicksStreamRequest instance) {
  final val = <String, dynamic>{
    'ticks': instance.ticks,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('subscribe', instance.subscribe);
  writeNotNull('passthrough', instance.passthrough);
  writeNotNull('req_id', instance.reqId);
  return val;
}

TicksStreamResponse _$TicksStreamResponseFromJson(Map<String, dynamic> json) =>
    TicksStreamResponse(
      subscription: Map<String, String>.from(json['subscription'] as Map),
      tick: Tick.fromJson(json['tick'] as Map<String, dynamic>),
      echoReq:
          TicksStreamRequest.fromJson(json['echo_req'] as Map<String, dynamic>),
      msgType: json['msg_type'] as String,
      reqId: json['req_id'] as int?,
    );

Map<String, dynamic> _$TicksStreamResponseToJson(TicksStreamResponse instance) {
  final val = <String, dynamic>{
    'subscription': instance.subscription,
    'tick': instance.tick.toJson(),
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
