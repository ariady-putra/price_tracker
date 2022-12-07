import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'cubit/cubit.dart';
import 'price_tracker_builder.dart';

class PriceTrackerPageProvider extends StatelessWidget {
  const PriceTrackerPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MarketCubit(),
        ),
        BlocProvider(
          create: (_) => AssetCubit(),
        ),
        BlocProvider(
          create: (_) => PriceCubit(),
        ),
      ],
      child: const PriceTrackerPageBuilder(),
    );
  }
}
