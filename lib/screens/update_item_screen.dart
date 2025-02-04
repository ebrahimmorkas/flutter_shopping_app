import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/providers/grocery_items_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateItemScreen extends ConsumerStatefulWidget {
  const UpdateItemScreen({super.key, required this.item});

  final GroceryItem item;

  @override
  ConsumerState<UpdateItemScreen> createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends ConsumerState<UpdateItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _enteredName;
  late int _enteredQuantity;
  late Category _selectedCategory;

  String _updatedName = '';
  @override
  void initState() {
    super.initState();
    _enteredName = widget.item.name;
    _enteredQuantity = widget.item.quantity;
    _selectedCategory = widget.item.category;
  }

  bool isUpdating = false;

  // Function that will update the item
  Future updateItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isUpdating = true;
      });
    }

    final url = Uri.https('shopping-list-7df26-default-rtdb.firebaseio.com',
        'shopping_list/${widget.item.id}.json');
    try {
      // print(_updatedName);
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{
            'name': _updatedName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.title,
          },
        ),
      );
      if (response.statusCode == 200) {
        // print(response.statusCode);
        if (context.mounted) {
          ref.read(groceryItemsListProvider.notifier).fetchData();
          Navigator.pop(context);
        } else {
          return;
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        } else {
          return;
        }
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Problem in updation"),
          ),
        );
      }
    } catch (error) {
      // Catch block
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Item"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _enteredName,
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Must be between 1 and 50 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _updatedName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _enteredQuantity.toString(),
                      maxLength: 50,
                      decoration: InputDecoration(
                        label: Text("Quantity"),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value)! <= 0) {
                          return "Please enter a valid number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      // value: categories.containsValue(_selectedCategory),
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem<Category>(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title),
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: !isUpdating
                        ? () {
                            _formKey.currentState!.reset();
                            _selectedCategory =
                                categories[Categories.vegetables]!;
                          }
                        : null,
                    child: Text("Reset"),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: !isUpdating ? updateItem : null,
                    child:
                        !isUpdating ? Text("Update Item") : Text("Updating..."),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
