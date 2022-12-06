import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'asset_state.dart';

class AssetCubit extends Cubit<AssetState?> {
  AssetCubit() : super(null);

  void updateCurrentAsset(
    String assetSymbol,
    String displayName,
  ) =>
      emit(
        AssetState(
          assetSymbol: assetSymbol,
          displayName: displayName,
        ),
      );

  void unselectAsset() => emit(null);
}
