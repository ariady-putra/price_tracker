import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit()
      : super(
          const MarketState.init(),
        );

  void updateCurrentMarket(
    String market,
    String displayName,
  ) =>
      emit(
        MarketState.update(
          market,
          displayName,
        ),
      );

  void unselectMarket() => emit(
        const MarketState(
          market: null,
          displayName: null,
        ),
      );
}
