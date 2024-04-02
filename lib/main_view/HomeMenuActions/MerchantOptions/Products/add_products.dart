import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_category_api.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/Products/add_product_images.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../APIs/AdminActionAPI/admin_get_users_api.dart';
import '../../../../Constants/SharedPreferences/key_names.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Users? user;
  String? username;
  late Future<List<ProductCategory>> _categories;
  ProductCategory? _selectedCategory;
  String? userCompany;

  void getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString(PrefsKeys.userName);
    if (username != null) {
      user = await UserCRUD().getByUsername(username!);
      userCompany = user?.userCompany;
      if (userCompany != null) {
        _companyController.text = userCompany ?? '';
      }
    }
  }

  @override
  void initState() {
    getUsername();
    _categories = ProductCategoryAPI().getCategories();
    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  late final TextEditingController _companyController = TextEditingController();

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
                    value: _selectedCategory,
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.categoryName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            AddProductTextField(
              label: 'Name',
              hint: 'Name',
              controller: _nameController,
              readOnly: false,
            ),
            AddProductTextField(
              label: 'Description',
              hint: 'Description',
              controller: _descriptionController,
              readOnly: false,
            ),
            AddProductTextField(
              label: 'Price',
              hint: 'Price',
              controller: _priceController,
              readOnly: false,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            AddProductTextField(
              label: 'Stock',
              hint: 'Stock',
              controller: _stockController,
              readOnly: false,
              keyboardType: TextInputType.number,
            ),
            AddProductTextField(
              label: 'Company',
              hint: 'Company',
              controller: _companyController,
              readOnly: true,
            ),
            ElevatedButton(
              onPressed: () {
                ItemCRUD().createItem(
                  _nameController.text,
                  _descriptionController.text,
                  double.parse(_priceController.text),
                  int.parse(_stockController.text),
                  _selectedCategory!.categoryName,
                  _companyController.text,
                  (success) {
                    onSuccess(context, success, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProductImages(),
                        ),
                      );
                    });
                  },
                  (error) {
                    onError(context, error);
                  },
                );
              },
              child: const Text('Add Product'),
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
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          label: Text(label),
          hintText: hint,
          alignLabelWithHint: true,
        ),
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
      ),
    );
  }
}
