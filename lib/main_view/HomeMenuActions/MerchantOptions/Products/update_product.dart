import 'package:flutter/material.dart';

import '../../../../APIs/AdminActionAPI/item_management_api.dart';

class UpdateProducts extends StatefulWidget {
  final int itemId;

  const UpdateProducts({Key? key, required this.itemId}) : super(key: key);

  @override
  State<UpdateProducts> createState() => _UpdateProductsState();
}

class _UpdateProductsState extends State<UpdateProducts> {
  late Future<Item> futureItem;
  final TextEditingController productNameController = TextEditingController();

  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productStockController = TextEditingController();
  final TextEditingController productCategoryController =
      TextEditingController();
  final TextEditingController productPriceController = TextEditingController();

  @override
  void initState() {
    futureItem = ItemCRUD().readByProductId(widget.itemId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: FutureBuilder<Item>(
        future: futureItem,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            Item item = snapshot.data!;
            _initializeControllers(item);
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField(
                    productNameController,
                    'Name',
                    TextInputType.text,
                  ),
                  _buildTextField(
                    productCategoryController,
                    'Category',
                    TextInputType.text,
                  ),
                  _buildTextField(
                    productDescriptionController,
                    'Description',
                    TextInputType.multiline,
                    minLines: 5,
                    maxLines: 10,
                  ),
                  _buildTextField(
                    productPriceController,
                    'Price',
                    TextInputType.text,
                  ),
                  _buildTextField(
                    productStockController,
                    'Stock',
                    TextInputType.text,
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _initializeControllers(Item item) {
    productStockController.text = item.productStock;
    productCategoryController.text = item.productCategory;
    productNameController.text = item.productName;
    productPriceController.text = item.productPrice;
    productDescriptionController.text = item.description;
  }

  Widget _buildTextField(
      TextEditingController controller, String hintAndLabel, TextInputType type,
      {int? minLines, int? maxLines}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        readOnly: false,
        keyboardType: type,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          label: Text(hintAndLabel),
          hintText: hintAndLabel,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        autocorrect: false,
        maxLines: maxLines,
        minLines: minLines,
      ),
    );
  }
}
