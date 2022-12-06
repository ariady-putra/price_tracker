part of 'asset_cubit.dart';

class AssetState extends Equatable {
  const AssetState({
    required this.assetSymbol,
    required this.displayName,
  });

  final String? assetSymbol;
  final String? displayName;

  @override
  List<Object?> get props => [assetSymbol];
}
