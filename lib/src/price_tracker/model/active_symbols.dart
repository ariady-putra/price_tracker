import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'base/base.dart';

part 'active_symbols.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class ActiveSymbol {
  String market; // "synthetic_index"
  String marketDisplayName; // "Derived"
  String subgroup; // "baskets"
  String subgroupDisplayName; // "Baskets"
  String submarket; // "forex_basket"
  String submarketDisplayName; // "Forex Basket"
  String symbolType; // "forex_basket"
  String symbol; // "WLDAUD"
  String displayName; // "AUD Basket"
  int displayOrder; // 22
  int allowForwardStarting; // 0
  int exchangeIsOpen; // 0
  int isTradingSuspended; // 0
  double pip; // 0.001

  ActiveSymbol({
    required this.market,
    required this.marketDisplayName,
    required this.subgroup,
    required this.subgroupDisplayName,
    required this.submarket,
    required this.submarketDisplayName,
    required this.symbolType,
    required this.symbol,
    required this.displayName,
    required this.displayOrder,
    required this.allowForwardStarting,
    required this.exchangeIsOpen,
    required this.isTradingSuspended,
    required this.pip,
  });

  factory ActiveSymbol.fromJson(Map<String, dynamic> json) =>
      _$ActiveSymbolFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveSymbolToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
/*
  {
    "active_symbols": "brief",
    "product_type": "basic"
  }
*/
class ActiveSymbolsRequest implements Request {
  String activeSymbols;
  String productType;

  ActiveSymbolsRequest({
    this.activeSymbols = 'brief',
    this.productType = 'basic',
    this.landingCompany,
    this.passthrough,
    this.reqId,
  });

  String? landingCompany;

  Object? passthrough;
  int? reqId;

  factory ActiveSymbolsRequest.fromJson(Map<String, dynamic> json) =>
      _$ActiveSymbolsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveSymbolsRequestToJson(this);

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
    "active_symbols": [],
    "echo_req": {
      "active_symbols": "brief",
      "product_type": "basic",
      "req_id": 1
    },
    "msg_type": "active_symbols",
    "req_id": 1
  }
*/
class ActiveSymbolsResponse implements Response {
  List<ActiveSymbol> activeSymbols;

  ActiveSymbolsResponse({
    required this.activeSymbols,
    required this.echoReq,
    required this.msgType,
    this.reqId,
  });

  ActiveSymbolsRequest echoReq;
  String msgType;

  int? reqId;

  factory ActiveSymbolsResponse.fromJson(Map<String, dynamic> json) =>
      _$ActiveSymbolsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveSymbolsResponseToJson(this);

  @override
  jsonDecode(String source) => ActiveSymbolsResponse.fromJson(
        json.decode(source),
      );
}
