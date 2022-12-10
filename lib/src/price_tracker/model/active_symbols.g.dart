// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_symbols.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveSymbol _$ActiveSymbolFromJson(Map<String, dynamic> json) => ActiveSymbol(
      market: json['market'] as String,
      marketDisplayName: json['market_display_name'] as String,
      subgroup: json['subgroup'] as String,
      subgroupDisplayName: json['subgroup_display_name'] as String,
      submarket: json['submarket'] as String,
      submarketDisplayName: json['submarket_display_name'] as String,
      symbolType: json['symbol_type'] as String,
      symbol: json['symbol'] as String,
      displayName: json['display_name'] as String,
      displayOrder: json['display_order'] as int,
      allowForwardStarting: json['allow_forward_starting'] as int,
      exchangeIsOpen: json['exchange_is_open'] as int,
      isTradingSuspended: json['is_trading_suspended'] as int,
      pip: (json['pip'] as num).toDouble(),
    );

Map<String, dynamic> _$ActiveSymbolToJson(ActiveSymbol instance) =>
    <String, dynamic>{
      'market': instance.market,
      'market_display_name': instance.marketDisplayName,
      'subgroup': instance.subgroup,
      'subgroup_display_name': instance.subgroupDisplayName,
      'submarket': instance.submarket,
      'submarket_display_name': instance.submarketDisplayName,
      'symbol_type': instance.symbolType,
      'symbol': instance.symbol,
      'display_name': instance.displayName,
      'display_order': instance.displayOrder,
      'allow_forward_starting': instance.allowForwardStarting,
      'exchange_is_open': instance.exchangeIsOpen,
      'is_trading_suspended': instance.isTradingSuspended,
      'pip': instance.pip,
    };

ActiveSymbolsRequest _$ActiveSymbolsRequestFromJson(
        Map<String, dynamic> json) =>
    ActiveSymbolsRequest(
      activeSymbols: json['active_symbols'] as String? ?? 'brief',
      productType: json['product_type'] as String? ?? 'basic',
      landingCompany: json['landing_company'] as String?,
      passthrough: json['passthrough'],
      reqId: json['req_id'] as int?,
    );

Map<String, dynamic> _$ActiveSymbolsRequestToJson(
    ActiveSymbolsRequest instance) {
  final val = <String, dynamic>{
    'active_symbols': instance.activeSymbols,
    'product_type': instance.productType,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('landing_company', instance.landingCompany);
  writeNotNull('passthrough', instance.passthrough);
  writeNotNull('req_id', instance.reqId);
  return val;
}

ActiveSymbolsResponse _$ActiveSymbolsResponseFromJson(
        Map<String, dynamic> json) =>
    ActiveSymbolsResponse(
      activeSymbols: (json['active_symbols'] as List<dynamic>)
          .map((e) => ActiveSymbol.fromJson(e as Map<String, dynamic>))
          .toList(),
      echoReq: ActiveSymbolsRequest.fromJson(
          json['echo_req'] as Map<String, dynamic>),
      msgType: json['msg_type'] as String,
      reqId: json['req_id'] as int?,
    );

Map<String, dynamic> _$ActiveSymbolsResponseToJson(
    ActiveSymbolsResponse instance) {
  final val = <String, dynamic>{
    'active_symbols': instance.activeSymbols.map((e) => e.toJson()).toList(),
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
