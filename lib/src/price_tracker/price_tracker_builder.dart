import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'cubit/cubit.dart';
import 'price_tracker_view.dart';

class PriceTrackerPageBuilder extends StatelessWidget {
  const PriceTrackerPageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCubit, MarketState?>(
      builder: (marketContext, marketState) =>
          BlocBuilder<AssetCubit, AssetState?>(
        builder: (assetContext, assetState) =>
            BlocBuilder<PriceCubit, PriceState>(
          builder: (priceContext, priceState) => PriceTrackerView(
            marketContext: marketContext,
            marketState: marketState,
            assetContext: assetContext,
            assetState: assetState,
            priceContext: priceContext,
            priceState: priceState,
          ),
        ),
      ),
    );
  }
}
