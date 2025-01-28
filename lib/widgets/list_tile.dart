import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';

class Listtile extends StatelessWidget {
  const Listtile({super.key, required this.groceryItem});

  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        color: groceryItem.category.color,
      ),
      title: Text(groceryItem.name),
      trailing: Text(groceryItem.quantity.toString()),
    );
  }
}
