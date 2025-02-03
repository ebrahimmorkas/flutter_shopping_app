import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';

class GroceryItemsListProvider extends StateNotifier<List<GroceryItem>> {
  GroceryItemsListProvider() : super([]) {
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.https('shopping-list-7df26-default-rtdb.firebaseio.com',
        'shopping_list.json');
    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (var data in data.entries) {
        loadedItems.add(
          GroceryItem(
            id: data.key,
            name: data.value['name'],
            quantity: data.value['quantity'],
            category: Category(
                title: data.value['category'],
                // The below code is for selecting the color.
                // The logic is that with the help of firstWhere() methid we are returning only that value form the map of categories which is stored is categories.dart file in data folder that matches the title stored in firebase.
                color: categories.entries
                    .firstWhere(
                      (catItem) {
                        return catItem.value.title == data.value['category'];
                      },
                    )
                    .value
                    .color),
          ),
        );
      }

      state = loadedItems;
    } catch (error) {
      // print("An error has taken place $error");
    }
  }

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
