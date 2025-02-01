import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/models/grocery_item.dart';

class GroceryItemsListProvider extends StateNotifier<List<GroceryItem>> {
  GroceryItemsListProvider() : super([]);

  void addItem(GroceryItem newItem) {
    state = [...state, newItem];
  }

  void removeItem(GroceryItem item) {
    state = state.where((singleItem) => singleItem != item).toList();
  }
}

final groceryItemsListProvider =
    StateNotifierProvider<GroceryItemsListProvider, List<GroceryItem>>(
  (ref) {
    return GroceryItemsListProvider();
  },
);
