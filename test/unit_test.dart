// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_tracker/src/price_tracker/cubit/cubit.dart';

void main() {
  group(
    'Price Up',
    () {
      test(
        'should be green',
        () {
          PriceCubit priceCubit = PriceCubit();

          priceCubit.updatePrice('', 50);
          priceCubit.updatePrice('', 75);

          expect(
            priceCubit.state.priceTextColor,
            Colors.green,
          );
        },
      );
    },
  );

  group(
    'Price Down',
    () {
      test(
        'should be red',
        () {
          PriceCubit priceCubit = PriceCubit();

          priceCubit.updatePrice('', 50);
          priceCubit.updatePrice('', 25);

          expect(
            priceCubit.state.priceTextColor,
            Colors.red,
          );
        },
      );
    },
  );
}
