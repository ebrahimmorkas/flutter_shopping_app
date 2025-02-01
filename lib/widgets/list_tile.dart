import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/providers/grocery_items_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Listtile extends ConsumerStatefulWidget {
  const Listtile({super.key, required this.groceryItem, required this.index});

  final GroceryItem groceryItem;
  final int index;

  @override
  ConsumerState<Listtile> createState() => _ListtileState();
}

class _ListtileState extends ConsumerState<Listtile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.groceryItem.id),
      background: Container(
        color: const Color.fromARGB(208, 208, 158, 158),
      ),
      onDismissed: (direction) {
        final itemToBeDeleted = widget.groceryItem;
        final indexOfItemToBeDeleted = widget.index;
        final groceryNotifier = ref.read(groceryItemsListProvider.notifier);

        groceryNotifier.removeItem(widget.groceryItem);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Item Deleted"),
            action: SnackBarAction(
                label: "Undo",
                onPressed: () {
                  groceryNotifier.undoRemoveItem(
                      itemToBeDeleted, indexOfItemToBeDeleted);
                }),
          ),
        );
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
