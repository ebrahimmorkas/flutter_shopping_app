import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/providers/grocery_items_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Listtile extends ConsumerStatefulWidget {
  const Listtile({super.key, required this.groceryItem, required this.index});

  final GroceryItem groceryItem;
  final int index;

  @override
  ConsumerState<Listtile> createState() => _ListtileState();
}

class _ListtileState extends ConsumerState<Listtile> {
  Future deleteFromDatabase(String id) async {
    final url = Uri.https('shopping-list-7df26-default-rtdb.firebaseio.com',
        'shopping_list/$id.json');

    final response = await http.delete(url);
    if (response.statusCode == 200) {
      print("Deletion successfull");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.groceryItem.id),
      background: Container(
        color: const Color.fromARGB(208, 208, 158, 158),
      ),
      onDismissed: (direction) {
        // The loic for deleting the data from database is simple with the help of delete request. But the logic for undo is as followed. When user swipes the item the item is removed from the UI but not from database. It is removed from the database when the snakcbar on the screen is removed. But when the snackbar is removed from the screen by clicking on action button that is 'undo' in our case then the data is not removed from database. The query for removing the data from database will only process when the snackbar is removed from the screen but not by clicking on action button that is 'undo' in our case.
        final itemToBeDeleted = widget.groceryItem;
        final indexOfItemToBeDeleted = widget.index;
        final groceryNotifier = ref.read(groceryItemsListProvider.notifier);

        groceryNotifier.removeItem(widget.groceryItem);

// We are assigning the variables for the snackbar because we want to handle the event when the snackbar is removed from the screen
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        // Removing the snackbar if there are any
        scaffoldMessenger.removeCurrentSnackBar();
        final snackBarController = scaffoldMessenger.showSnackBar(
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

        snackBarController.closed.then(
          (reason) {
            if (reason == SnackBarClosedReason.action) {
              // Undo has been clicked so no need to delete the item
              // print(reason);
              return;
            } else {
              // print(reason);
              deleteFromDatabase(itemToBeDeleted.id);
            }
          },
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
