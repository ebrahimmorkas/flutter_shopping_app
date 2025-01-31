import 'package:flutter/material.dart';
import 'package:shopping_app/screens/new_item_screen.dart';
import 'package:shopping_app/widgets/list_tile.dart';
import 'package:shopping_app/data/dummy_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewItemScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Listtile(
                groceryItem: groceryItems[index],
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
