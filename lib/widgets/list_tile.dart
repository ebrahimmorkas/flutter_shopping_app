import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';

class Listtile extends StatefulWidget {
  const Listtile({super.key, required this.groceryItem, required this.index});

  final GroceryItem groceryItem;
  final int index;

  @override
  State<Listtile> createState() => _ListtileState();
}

class _ListtileState extends State<Listtile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.index),
      background: Container(
        color: const Color.fromARGB(208, 208, 158, 158),
      ),
      onDismissed: (direction) {
        setState(() {});
      },
      child: ListTile(
        leading: Container(
          width: 50,
          color: widget.groceryItem.category.color,
        ),
        title: Text(widget.groceryItem.name),
        trailing: Text(widget.groceryItem.quantity.toString()),
      ),
    );
  }
}
