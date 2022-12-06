import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState?> {
  MarketCubit() : super(null);

  void updateCurrentMarket(
    String market,
    String displayName,
  ) =>
      emit(
        MarketState(
          market: market,
          displayName: displayName,
        ),
      );

  void unselectMarket() => emit(null);
}
