part of 'price_cubit.dart';

class PriceState extends Equatable {
  const PriceState({
    this.subscriptionId,
    this.currentPrice,
    this.priceTextColor,
  });

  const PriceState.init({
    this.subscriptionId,
    this.currentPrice,
    this.priceTextColor,
  });

  const PriceState.update(
    this.subscriptionId,
    this.currentPrice,
    this.priceTextColor,
  );

  final String? subscriptionId;
  final double? currentPrice;
  final Color? priceTextColor;

  @override
  List<Object?> get props => [
        subscriptionId,
        currentPrice,
      ];
}
