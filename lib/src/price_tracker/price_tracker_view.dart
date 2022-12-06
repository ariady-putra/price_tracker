import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../settings/settings_view.dart';

class PriceTrackerView extends StatefulWidget {
  const PriceTrackerView({super.key});

  static const routeName = '/price_tracker';
  static const appId = 1089;

  @override
  State<PriceTrackerView> createState() => _PriceTrackerViewState();
}

class _PriceTrackerViewState extends State<PriceTrackerView> {
  WebSocketChannel? _channel;

  void _connect() => setState(
        () => _channel = WebSocketChannel.connect(
          Uri.parse(
            'wss://ws.binaryws.com/websockets/v3?app_id=${PriceTrackerView.appId}',
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    _connect();
    _requestActiveSymbols();
  }

  @override
  void dispose() {
    _channel!.sink.close();
    super.dispose();
  }

  void _requestActiveSymbols() {
    _channel!.sink.add(
      json.encode(
        {
          'active_symbols': 'brief',
          'product_type': 'basic',
        },
      ),
    );
  }

  bool _isSubscribing = false;
  void _requestTicksStream(String assetSymbol) {
    _isSubscribing = true;
    _channel!.sink.add(
      json.encode(
        {
          'ticks': assetSymbol,
          'subscribe': 1,
        },
      ),
    );
  }

  void _requestForget(String subscriptionId) {
    _currentPrice = null;
    _channel!.sink.add(
      json.encode(
        {
          'forget': subscriptionId,
        },
      ),
    );
    _isSubscribing = false;
  }

  void _reconnect() {
    _channel!.sink.close();
    _connect();
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Map? _marketData;
  Map? _distinctMarkets;
  List? _activeSymbols;
  Widget _showMarket(Map data) {
    _marketData ??= data;
    _activeSymbols ??= _marketData!['active_symbols'];

    if (_distinctMarkets == null) {
      _distinctMarkets = {};

      for (final Map activeSymbol in _activeSymbols!) {
        _distinctMarkets!.putIfAbsent(
            activeSymbol['market'], () => activeSymbol['market_display_name']);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              _marketDropdown(_distinctMarkets!.entries),
              _assetDropdown(_activeSymbols!),
              if (_isSubscribing)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _assetPrice(data['tick']),
                )
            ],
          ),
        ),
      ),
    );
  }

  Object? _selectedMarket;
  Widget _marketDropdown(Iterable marketMapEntries) {
    return DropdownButton(
      hint: Text(AppLocalizations.of(context)!.selectAMarket),
      items: marketMapEntries
          .map(
            (e) => DropdownMenuItem(
              value: e.key,
              child: Text(e.value),
            ),
          )
          .toList(),
      value: _selectedMarket,
      onChanged: (value) => setState(
        () {
          _selectedMarket = value;
          _selectedAsset = null;
          if (_priceTickerSubscriptionId != null) {
            _requestForget(_priceTickerSubscriptionId!);
          }
        },
      ),
    );
  }

  Object? _selectedAsset;
  Widget _assetDropdown(List activeSymbolList) {
    return DropdownButton(
      hint: Text(AppLocalizations.of(context)!.selectAnAsset),
      items: activeSymbolList
          .where(
            (element) => element['market'] == _selectedMarket,
          )
          .map(
            (e) => DropdownMenuItem(
              value: e['symbol'],
              child: Text(e['display_name']),
            ),
          )
          .toList(),
      value: _selectedAsset,
      onChanged: (value) => setState(
        () {
          _selectedAsset = value;

          if (_priceTickerSubscriptionId != null) {
            _requestForget(_priceTickerSubscriptionId!);
          }

          _requestTicksStream('$_selectedAsset');
        },
      ),
    );
  }

  double? _currentPrice;
  String? _priceTickerSubscriptionId;
  Widget _assetPrice(Map? tick) {
    if (tick == null) return _loading();

    _priceTickerSubscriptionId = tick['id'];

    Color? priceTextColor;
    if (_currentPrice != null) {
      if (tick['quote'] < _currentPrice) priceTextColor = Colors.red;
      if (tick['quote'] > _currentPrice) priceTextColor = Colors.green;
    }
    _currentPrice = tick['quote'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(' ${AppLocalizations.of(context)!.price}: '),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            color: priceTextColor,
            fontWeight: FontWeight.bold,
          ),
          child: Text(' $_currentPrice '),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: _channel!.stream,
        builder: (context, snapshot) => snapshot.hasData
            ? _showMarket(
                json.decode(snapshot.data),
              )
            : _loading(),
      ),
    );
  }
}
