part of 'price_cubit.dart';

class PriceState extends Equatable {
  const PriceState({
    this.currentPrice,
    this.priceTextColor,
  });

  final double? currentPrice;
  final Color? priceTextColor;

  @override
  List<Object?> get props => [currentPrice];
}
