import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../settings/settings_view.dart';
import 'cubit/asset_cubit.dart';
import 'cubit/cubit.dart';

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

  void _requestForget({
    required String subscriptionId,
    required BuildContext priceContext,
  }) {
    priceContext.read<PriceCubit>().currentPrice = null; // to clear text color
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
      body: BlocProvider(
        create: (_) => AssetCubit(),
        child: BlocProvider(
          create: (_) => PriceCubit(),
          child: BlocBuilder<AssetCubit, AssetState>(
            builder: (assetContext, assetState) =>
                BlocBuilder<PriceCubit, PriceState>(
              builder: (priceContext, priceState) => Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      // Market selection
                      _marketDropdown(
                        marketMapEntries: _distinctMarkets!.entries,
                        assetContext: assetContext,
                        priceContext: priceContext,
                      ),

                      // Asset selection
                      _assetDropdown(
                        activeSymbolList: _activeSymbols!,
                        assetState: assetState,
                        assetContext: assetContext,
                        priceContext: priceContext,
                      ),

                      // Price ticker
                      if (_isSubscribing)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: _assetPrice(
                            tick: data['tick'],
                            priceState: priceState,
                            priceContext: priceContext,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Object? _selectedMarket;
  Widget _marketDropdown({
    required Iterable marketMapEntries,
    required BuildContext assetContext,
    required BuildContext priceContext,
  }) {
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
          assetContext.read<AssetCubit>().unselectAsset();

          // Always unsubscribe from any price ticker subscription on market change
          if (_priceTickerSubscriptionId != null) {
            _requestForget(
              subscriptionId: _priceTickerSubscriptionId!,
              priceContext: priceContext,
            );
          }
        },
      ),
    );
  }

  Widget _assetDropdown({
    required List activeSymbolList,
    required AssetState assetState,
    required BuildContext assetContext,
    required BuildContext priceContext,
  }) {
    return DropdownButton(
      hint: Text(AppLocalizations.of(context)!.selectAnAsset),
      items: activeSymbolList
          .where(
            (element) => element['market'] == _selectedMarket,
          )
          .map(
            (e) => DropdownMenuItem(
              value: AssetState(
                assetSymbol: e['symbol'],
                displayName: e['display_name'],
              ),
              child: Text(e['display_name']),
            ),
          )
          .toList(),
      value: assetState.assetSymbol == null ? null : assetState,
      onChanged: (value) => setState(
        () {
          if (value == null) {
            assetContext.read<AssetCubit>().unselectAsset();
          } else {
            assetContext.read<AssetCubit>().updateCurrentAsset(
                  value.assetSymbol!,
                  value.displayName!,
                );
          }

          // Unsubscribe from any previous price ticker subscription
          if (_priceTickerSubscriptionId != null) {
            _requestForget(
              subscriptionId: _priceTickerSubscriptionId!,
              priceContext: priceContext,
            );
          }

          // Subscribe to the selected asset
          _requestTicksStream('${value!.assetSymbol}');
        },
      ),
    );
  }

  String? _priceTickerSubscriptionId;
  Widget _assetPrice({
    required Map? tick,
    required PriceState priceState,
    required BuildContext priceContext,
  }) {
    if (tick == null) return _loading();

    _priceTickerSubscriptionId = tick['id'];

    priceContext.read<PriceCubit>().currentPrice = tick['quote'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(' ${AppLocalizations.of(context)!.price}: '),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            color: priceState.priceTextColor,
            fontWeight: FontWeight.bold,
          ),
          child: Text(' ${priceState.currentPrice} '),
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
