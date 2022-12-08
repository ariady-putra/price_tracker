import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../settings/settings_view.dart';
import 'cubit/cubit.dart';

class PriceTrackerView extends StatefulWidget {
  const PriceTrackerView({
    required this.marketContext,
    required this.marketState,
    required this.assetContext,
    required this.assetState,
    required this.priceContext,
    required this.priceState,
    super.key,
  });

  final BuildContext marketContext;
  final MarketState? marketState;

  final BuildContext assetContext;
  final AssetState? assetState;

  final BuildContext priceContext;
  final PriceState priceState;

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

  late ValueNotifier<bool> _isSubscribing;

  @override
  void initState() {
    super.initState();

    _connect();
    _requestActiveSymbols();

    _isSubscribing = ValueNotifier(false);
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

  void _requestTicksStream(String? assetSymbol) {
    _isSubscribing.value = true;
    if (assetSymbol != null) {
      _channel!.sink.add(
        json.encode(
          {
            'ticks': assetSymbol,
            'subscribe': 1,
          },
        ),
      );
    }
  }

  void _requestForget(String? subscriptionId) {
    widget.priceContext.read<PriceCubit>().reset(); // unset price text color
    if (subscriptionId != null) {
      _channel!.sink.add(
        json.encode(
          {
            'forget': subscriptionId,
          },
        ),
      );
    }
    _isSubscribing.value = false;
  }

  void _requestForgetAll() {
    widget.priceContext.read<PriceCubit>().reset(); // unset price text color
    _channel!.sink.add(
      json.encode(
        {
          'forget_all': 'ticks',
        },
      ),
    );
    _isSubscribing.value = false;
  }

  void _resetConnection() {
    _channel!.sink.close();
    _connect();
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future? _delayShowStopLoadingButton() async {
    await Future.delayed(
      const Duration(milliseconds: 2500),
    );
    return 1;
  }

  Map? _marketData;
  Map? _distinctMarkets;
  List? _activeSymbols;
  Widget _showMarket(Map data) {
    _marketData ??= data; // set market data if null
    _activeSymbols ??= _marketData!['active_symbols'];

    if (_distinctMarkets == null) {
      _distinctMarkets = {};
      // select distinct markets
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
          child: ValueListenableBuilder(
            valueListenable: _isSubscribing,
            builder: (_, isSubscribed, c) => Column(
              children: [
                IntrinsicHeight(
                  child: Stack(
                    children: [
                      // Show the market access
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            // Market selection
                            _marketDropdown(_distinctMarkets!.entries),

                            // Asset selection
                            _assetDropdown(_activeSymbols!),
                          ],
                        ),
                      ),

                      // Block the market access while loading
                      if (isSubscribed && data['tick'] == null)
                        const ModalBarrier(),
                    ],
                  ),
                ),

                // Price ticker
                if (isSubscribed)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _assetPrice(data['tick']),
                  ),

                // If it's loading for too long
                if (isSubscribed && data['tick'] == null)
                  FutureBuilder(
                    future: _delayShowStopLoadingButton(),
                    builder: (_, snapshot) => snapshot.hasData
                        ? ElevatedButton(
                            onPressed: () => setState(
                              () {
                                widget.marketContext
                                    .read<MarketCubit>()
                                    .unselectMarket();
                                widget.assetContext
                                    .read<AssetCubit>()
                                    .unselectAsset();
                                _requestForgetAll();
                              },
                            ),
                            child:
                                Text(AppLocalizations.of(context)!.stopLoading),
                          )
                        : Container(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _marketDropdown(Iterable marketMapEntries) {
    return DropdownButton(
      hint: Text(AppLocalizations.of(context)!.selectAMarket),
      items: marketMapEntries
          .map(
            (e) => DropdownMenuItem(
              value: MarketState(
                market: e.key,
                displayName: e.value,
              ),
              child: Text(e.value),
            ),
          )
          .toList(),
      value: widget.marketState,
      onChanged: (value) => setState(
        () {
          if (value == null) {
            widget.marketContext.read<MarketCubit>().unselectMarket();
          } else {
            widget.marketContext
                .read<MarketCubit>()
                .updateCurrentMarket(value.market!, value.displayName!);
          }
          widget.assetContext.read<AssetCubit>().unselectAsset();

          // Always unsubscribe from any price ticker subscription on market change
          _requestForget(widget.priceState.subscriptionId);
        },
      ),
    );
  }

  Widget _assetDropdown(List activeSymbolList) {
    return DropdownButton(
      hint: Text(AppLocalizations.of(context)!.selectAnAsset),
      items: widget.marketState == null
          ? <DropdownMenuItem<AssetState>>[]
          : activeSymbolList
              .where(
                (element) => element['market'] == widget.marketState!.market,
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
      value: widget.assetState,
      onChanged: (value) => setState(
        () {
          if (value == null) {
            widget.assetContext.read<AssetCubit>().unselectAsset();
          } else {
            widget.assetContext.read<AssetCubit>().updateCurrentAsset(
                  value.assetSymbol!,
                  value.displayName!,
                );
          }

          // Unsubscribe from any previous price ticker subscription
          _requestForget(widget.priceState.subscriptionId);

          // Subscribe to the selected asset
          _requestTicksStream('${value!.assetSymbol}');
        },
      ),
    );
  }

  Widget _assetPrice(Map? tick) {
    if (tick == null) return _loading();

    widget.priceContext.read<PriceCubit>().updatePrice(
          '${tick['id']}',
          double.parse('${tick['quote']}'),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(' ${AppLocalizations.of(context)!.price}: '),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            color: widget.priceState.priceTextColor ??
                Theme.of(context).textTheme.caption!.color,
            fontWeight: FontWeight.bold,
          ),
          child: Text(' ${widget.priceState.currentPrice} '),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _channel!.stream,
      builder: (_, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return _showMarket(
              json.decode(snapshot.data),
            );
          default:
            return _loading();
        }
      },
    );
  }
}
