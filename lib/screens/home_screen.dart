import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/screens/new_item_screen.dart';
import 'package:shopping_app/widgets/list_tile.dart';
import 'package:shopping_app/providers/grocery_items_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shopping_app/data/dummy_data.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(groceryItemsListProvider.notifier).fetchData();
  }
  // List groceryItems = [];

  @override
  Widget build(BuildContext context) {
    List<GroceryItem> groceryItems = ref.watch(groceryItemsListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: () async {
              final newItem = await Navigator.push<GroceryItem>(
                context,
                MaterialPageRoute(
                  builder: (context) => NewItemScreen(),
                ),
              );

              if (newItem == null) {
                return;
              } else {
                setState(() {
                  groceryItems.add(newItem);
                });
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: groceryItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Nothing to show here"),
                  SizedBox(height: 8),
                  Text("Get started by adding the items"),
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Listtile(
                      groceryItem: groceryItems[index],
                      index: index,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                );
              },
              itemCount: groceryItems.length,
            ),
    );
  }
}
