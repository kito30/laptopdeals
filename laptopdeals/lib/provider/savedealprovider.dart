import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laptopdeals/models/laptop.dart';

class SaveDealProvider extends Notifier<Set<Laptop>> {
  @override
  Set<Laptop> build() {
    return {};
  }

  void saveDeal(Laptop laptop) {
    // Check if a laptop with the same ID already exists
    if (!state.any((lap) => lap.id == laptop.id)) {
      state = {...state, laptop};
    }
  }

  void removeDeal(Laptop laptop) {
    // Remove laptop with matching ID
    state = state.where((lap) => lap.id != laptop.id).toSet();
  }
}

final saveDealProvider = NotifierProvider<SaveDealProvider, Set<Laptop>>(() {
  return SaveDealProvider();
});
