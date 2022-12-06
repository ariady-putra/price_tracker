part of 'market_cubit.dart';

class MarketState extends Equatable {
  const MarketState({
    required this.market,
    required this.displayName,
  });

  const MarketState.init({
    this.market,
    this.displayName,
  });

  const MarketState.update(
    this.market,
    this.displayName,
  );

  final String? market;
  final String? displayName;

  @override
  List<Object?> get props => [market];
}
