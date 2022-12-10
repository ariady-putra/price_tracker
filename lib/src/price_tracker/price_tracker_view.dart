import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../settings/settings_view.dart';
import 'cubit/cubit.dart';
import 'model/model.dart';

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

class _PriceTrackerViewState extends State<PriceTrackerView>
    with WidgetsBindingObserver {
  WebSocketChannel? _channel;
  void _connect() => setState(
        () => _channel = WebSocketChannel.connect(
          Uri.parse(
            'wss://ws.binaryws.com/websockets/v3?app_id=${PriceTrackerView.appId}',
          ),
        ),
      );

  late ValueNotifier<bool> _isSubscribing;
  late ValueNotifier<bool> _showStopLoadingButton;
  late ValueNotifier<bool> _showRetryConnectionButton;
  bool _isRetryingConnection = false;

  @override
  void initState() {
    super.initState();

    _connect(); // initiate the websocket connection
    _requestActiveSymbols(); // send ActiveSymbols request
    _listenToConnectivityChanged(); // listen for the connection state

    // Initialize flag-variables
    _isSubscribing = ValueNotifier(false);
    _showStopLoadingButton = ValueNotifier(false);
    _showRetryConnectionButton = ValueNotifier(false);

    // Show the RetryConnection button after waited for too long
    Future.delayed(
      const Duration(milliseconds: 2500),
    ).whenComplete(
      () => setState(
        () => _showRetryConnectionButton.value = true,
      ),
    );

    // Monitor the connection status by pinging the host
    Ping('binaryws.com').stream.listen(
          (ping) => setState(
            () {
              // if connection lost (eg. request time-out)
              if (ping.error != null) {
                // and if it's currently not retrying already,
                if (!_isRetryingConnection) {
                  // then retrying the connection.
                  _retryConnection();
                  _isRetryingConnection = true;
                }
              } else {
                // otherwise reset the connection retry flag
                _isRetryingConnection = false;
              }
            },
          ),
        );
  }

  @override
  void dispose() {
    _channel!.sink.close(); // close the websocket channel

    // Dispose flag-variables
    _showRetryConnectionButton.dispose();
    _showStopLoadingButton.dispose();
    _isSubscribing.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    /* connectivity_plus NOTES:
      Connectivity changes are no longer communicated to Android apps in the background starting with Android O.
      You should always check for connectivity status when your app is resumed.
      The broadcast is only useful when your application is in the foreground.
    */
    switch (state) {
      case AppLifecycleState.resumed:
        _listenToConnectivityChanged();
        break;

      default:
        break;
    }
  }

  void _listenToConnectivityChanged() =>
      Connectivity().onConnectivityChanged.listen(
        (connection) {
          switch (connection) {
            case ConnectivityResult.none: // no connection
              _retryConnection();
              break;

            default:
              break;
          }
        },
      );

  void _retryConnection() => setState(
        () {
          _showRetryConnectionButton.value = false;
          _resetConnection();
          _requestActiveSymbols();
          Future.delayed(
            const Duration(milliseconds: 2500),
          ).whenComplete(
            () => setState(
              () => _showRetryConnectionButton.value = true,
            ),
          );
        },
      );

  void _requestActiveSymbols() {
    _channel!.sink.add(
      ActiveSymbolsRequest().jsonEncode(),
    );
  }

  void _requestTicksStream(String? assetSymbol) {
    _showStopLoadingButton.value = false;
    _isSubscribing.value = true;
    if (assetSymbol != null) {
      _channel!.sink.add(
        TicksStreamRequest(
          ticks: assetSymbol,
          subscribe: 1,
        ).jsonEncode(),
      );
    }
    Future.delayed(
      const Duration(milliseconds: 2500),
    ).whenComplete(
      () => setState(
        () => _showStopLoadingButton.value = true,
      ),
    );
  }

  void _requestForget(String? subscriptionId) {
    widget.priceContext.read<PriceCubit>().reset(); // unset price text color
    if (subscriptionId != null) {
      _channel!.sink.add(
        ForgetRequest(forget: subscriptionId).jsonEncode(),
      );
    }
    _isSubscribing.value = false;
  }

  void _requestForgetAll() {
    widget.priceContext.read<PriceCubit>().reset(); // unset price text color
    _channel!.sink.add(
      ForgetAllRequest.ticks().jsonEncode(),
    );
    _isSubscribing.value = false;
  }

  void _resetConnection() {
    widget.marketContext.read<MarketCubit>().unselectMarket();
    widget.assetContext.read<AssetCubit>().unselectAsset();
    widget.priceContext.read<PriceCubit>().reset(); // unset price text color
    _isSubscribing.value = false;
    try {
      _channel!.sink.close();
    } catch (_) {}
    _channel = null;
    _connect();
  }

  final Map<String, String> _distinctMarkets = {};
  List<ActiveSymbol> _activeSymbols = [];
  TicksStreamResponse? _priceTickData;
  Widget _showMarket(Map<String, dynamic> data) {
    bool hasPriceData = false; // whether to render price data or not

    // Process websocket response data based on its msg_type
    switch (data['msg_type']) {
      case 'active_symbols': // Set market & asset data:
        final ActiveSymbolsResponse rsp = ActiveSymbolsResponse.fromJson(data);
        if (rsp.activeSymbols == null || rsp.activeSymbols!.isEmpty) break;

        // set sorted asset list
        _activeSymbols = rsp.activeSymbols!;
        _activeSymbols.sort(
          (a, b) => a.displayOrder.compareTo(b.displayOrder),
        );

        // set distinct markets
        for (final ActiveSymbol activeSymbol in _activeSymbols) {
          _distinctMarkets.putIfAbsent(
              activeSymbol.market, () => activeSymbol.marketDisplayName);
        }
        break;

      case 'tick': // Set price tick data:
        _priceTickData = TicksStreamResponse.fromJson(data);
        hasPriceData = _priceTickData != null &&
            _priceTickData!.subscription != null &&
            _priceTickData!.tick != null;
        break;

      default:
        break;
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
                            _marketDropdown(_distinctMarkets.entries),

                            // Asset selection
                            _assetDropdown(_activeSymbols),
                          ],
                        ),
                      ),

                      // Block the market access while loading...
                      if (isSubscribed && !hasPriceData) const ModalBarrier(),
                      // the condition is: subscribed to an asset but no price data yet
                    ],
                  ),
                ),

                // Price ticker
                if (isSubscribed)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: hasPriceData
                        ? _assetPrice(_priceTickData!)
                        : _loading(),
                  ),

                // If it's been loading for too long
                if (isSubscribed && !hasPriceData) _stopLoadingButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stopLoadingButton() {
    return ValueListenableBuilder(
      valueListenable: _showStopLoadingButton,
      builder: (_, showStopLoadingButton, c) => showStopLoadingButton
          ? ElevatedButton(
              onPressed: () => setState(
                () {
                  widget.marketContext.read<MarketCubit>().unselectMarket();
                  widget.assetContext.read<AssetCubit>().unselectAsset();
                  _requestForgetAll();
                },
              ),
              child: Text(AppLocalizations.of(context)!.stopLoading),
            )
          : Container(),
    );
  }

  Widget _marketDropdown(Iterable marketMapEntries) {
    return DropdownButton(
      hint: Text(AppLocalizations.of(context)!.selectAMarket),
      items: marketMapEntries
          .map(
            (market) => DropdownMenuItem(
              value: MarketState(
                market: market.key,
                displayName: market.value,
              ),
              child: Text(market.value),
            ),
          )
          .toList(),
      value: widget.marketState,
      onChanged: (market) => setState(
        () {
          if (market == null) {
            widget.marketContext.read<MarketCubit>().unselectMarket();
          } else {
            widget.marketContext
                .read<MarketCubit>()
                .updateCurrentMarket(market.market!, market.displayName!);
          }
          widget.assetContext.read<AssetCubit>().unselectAsset();

          // Always unsubscribe from any price ticker subscription on market change
          _requestForget(widget.priceState.subscriptionId);
        },
      ),
    );
  }

  Widget _assetDropdown(List<ActiveSymbol> activeSymbolList) {
    return DropdownButton(
      hint: Text(AppLocalizations.of(context)!.selectAnAsset),
      items: widget.marketState == null
          ? <DropdownMenuItem<AssetState>>[]
          : activeSymbolList
              .where(
                (activeSymbol) =>
                    activeSymbol.market == widget.marketState!.market,
              )
              .map(
                (activeSymbol) => DropdownMenuItem(
                  value: AssetState(
                    assetSymbol: activeSymbol.symbol,
                    displayName: activeSymbol.displayName,
                  ),
                  child: Text(activeSymbol.displayName),
                ),
              )
              .toList(),
      value: widget.assetState,
      onChanged: (asset) => setState(
        () {
          if (asset == null) {
            widget.assetContext.read<AssetCubit>().unselectAsset();
          } else {
            widget.assetContext.read<AssetCubit>().updateCurrentAsset(
                  asset.assetSymbol!,
                  asset.displayName!,
                );
          }

          // Unsubscribe from any previous price ticker subscription
          _requestForget(widget.priceState.subscriptionId);

          // Subscribe to the selected asset
          _requestTicksStream('${asset!.assetSymbol}');
        },
      ),
    );
  }

  Widget _assetPrice(TicksStreamResponse price) {
    widget.priceContext.read<PriceCubit>().updatePrice(
          price.subscription!.id,
          double.parse('${price.tick!.quote}'),
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

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _retryConnectionButton() {
    return ValueListenableBuilder(
      valueListenable: _showRetryConnectionButton,
      builder: (_, showRetryConnectionButton, c) => showRetryConnectionButton
          ? ElevatedButton(
              onPressed: _retryConnection,
              child: Text(AppLocalizations.of(context)!.retryConnection),
            )
          : const SizedBox(height: 28),
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 44),
                _loading(),
                const SizedBox(height: 16),
                _retryConnectionButton(),
              ],
            );
        }
      },
    );
  }
}
