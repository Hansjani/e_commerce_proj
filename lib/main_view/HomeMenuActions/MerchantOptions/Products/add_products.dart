import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_category_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../APIs/AdminActionAPI/admin_get_users_api.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late Future<Users?> user;
  String? username;
  late Future<List<ProductCategory>> _categories;
  ProductCategory? _selectedCategory;

  void getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _categories = ProductCategoryAPI().getCategories();
    username = prefs.getString("username");
  }

  @override
  void initState() {
    user = UserCRUD().getByUsername(username!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _categories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ProductCategory> categories = snapshot.data!;
                  return DropdownButton<ProductCategory>(
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: _selectedCategory,
                          child: Text(category.categoryName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedCategory = value;
                      },);
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'),);
                } else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductTextField extends StatelessWidget {
  const AddProductTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.readOnly,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(label),
        hintText: hint,
        alignLabelWithHint: true,
      ),
      controller: controller,
      readOnly: readOnly,
    );
  }
}
