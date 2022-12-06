import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'asset_state.dart';

class AssetCubit extends Cubit<AssetState> {
  AssetCubit()
      : super(
          const AssetState.init(),
        );

  void updateCurrentAsset(
    String assetSymbol,
    String displayName,
  ) =>
      emit(
        AssetState.update(
          assetSymbol,
          displayName,
        ),
      );

  void unselectAsset() => emit(
        const AssetState(
          assetSymbol: null,
          displayName: null,
        ),
      );
}
