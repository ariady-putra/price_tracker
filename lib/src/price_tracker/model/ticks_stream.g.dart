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
      subscription: json['subscription'] == null
          ? null
          : TickSubscription.fromJson(
              json['subscription'] as Map<String, dynamic>),
      tick: json['tick'] == null
          ? null
          : Tick.fromJson(json['tick'] as Map<String, dynamic>),
      echoReq:
          TicksStreamRequest.fromJson(json['echo_req'] as Map<String, dynamic>),
      msgType: json['msg_type'] as String,
      reqId: json['req_id'] as int?,
      error: json['error'] == null
          ? null
          : ResponseError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TicksStreamResponseToJson(TicksStreamResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('subscription', instance.subscription?.toJson());
  writeNotNull('tick', instance.tick?.toJson());
  val['echo_req'] = instance.echoReq.toJson();
  val['msg_type'] = instance.msgType;
  writeNotNull('req_id', instance.reqId);
  writeNotNull('error', instance.error?.toJson());
  return val;
}

TickSubscription _$TickSubscriptionFromJson(Map<String, dynamic> json) =>
    TickSubscription(
      id: json['id'] as String,
    );

Map<String, dynamic> _$TickSubscriptionToJson(TickSubscription instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
