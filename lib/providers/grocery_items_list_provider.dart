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

  void undoRemoveItem(GroceryItem oldItem, int index) {
    final newItemList = [...state];
    newItemList.insert(index, oldItem);
    state = newItemList;
  }
}

final groceryItemsListProvider =
    StateNotifierProvider<GroceryItemsListProvider, List<GroceryItem>>(
  (ref) {
    return GroceryItemsListProvider();
  },
);
