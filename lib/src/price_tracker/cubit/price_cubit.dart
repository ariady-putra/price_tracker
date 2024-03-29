import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'price_state.dart';

class PriceCubit extends Cubit<PriceState> {
  PriceCubit()
      : super(
          const PriceState.init(),
        );

  void updatePrice(String? subscriptionId, double? price) {
    Color? priceTextColor;
    // compare updated price from tick data to the current price
    if (price != null &&
        state.currentPrice != null &&
        subscriptionId == state.subscriptionId) {
      if (price < state.currentPrice!) priceTextColor = Colors.red;
      if (price > state.currentPrice!) priceTextColor = Colors.green;
    } // set the new text color accordingly
    return emit(
      PriceState.update(
        subscriptionId,
        price,
        priceTextColor,
      ),
    );
  }

  void reset() => emit(
        const PriceState(
          subscriptionId: null,
          currentPrice: null,
          priceTextColor: null,
        ),
      );
}
