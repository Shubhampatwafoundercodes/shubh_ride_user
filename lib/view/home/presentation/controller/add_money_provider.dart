import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Selected amount provider
// final selectedAmountProvider = StateProvider<int?>((ref) {
//   return null;
// });

/// TextEditingController provider (autoDispose so memory leak na ho)
final amountControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);

/// Preset amounts provider (future me backend se bhi aayenge to easy hoga)
final presetAmountsProvider = Provider<List<int>>((ref) {
  return [100, 200, 500, 1000];
});

class SelectedAmountNotifier extends StateNotifier<int?> {
  SelectedAmountNotifier() : super(0);

  void select(int? amount) => state = amount;
  void reset() => state = null;
}

final selectedAmountProvider = StateNotifierProvider<SelectedAmountNotifier, int?>(
      (ref) => SelectedAmountNotifier(),
);