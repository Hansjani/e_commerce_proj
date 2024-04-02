import 'package:flutter/material.dart';

import '../../../../APIs/AdminActionAPI/item_management_api.dart';

class UpdateProducts extends StatefulWidget {
  final int itemId;

  const UpdateProducts({super.key, required this.itemId});

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
    return FutureBuilder(
      future: futureItem,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          Item item = snapshot.data!;
          productStockController.text = item.productStock;
          productCategoryController.text = item.productCategory;
          productNameController.text = item.productName;
          productPriceController.text = item.productPrice;
          productDescriptionController.text = item.description;
          return Scaffold(
            appBar: AppBar(
              title: Text('Update : ${item.productName}'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  UpdateProductField(
                    controller: productNameController,
                    type: TextInputType.text,
                    hintAndLabel: 'Name',
                  ),
                  UpdateProductField(
                    controller: productCategoryController,
                    type: TextInputType.text,
                    hintAndLabel: 'Category',
                  ),
                  UpdateProductField(
                    controller: productDescriptionController,
                    type: TextInputType.multiline,
                    hintAndLabel: 'Description',
                    minLines: 5,
                    maxLines: 10,
                  ),
                  UpdateProductField(
                    controller: productPriceController,
                    type: TextInputType.text,
                    hintAndLabel: 'Price',
                  ),
                  UpdateProductField(
                    controller: productStockController,
                    type: TextInputType.text,
                    hintAndLabel: 'Stock',
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: Text('Could not load data'),
          );
        }
      },
    );
  }
}

class UpdateProductField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String hintAndLabel;
  final int? maxLines;
  final int? minLines;

  const UpdateProductField({
    super.key,
    required this.controller,
    required this.type,
    required this.hintAndLabel,
    this.maxLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
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
