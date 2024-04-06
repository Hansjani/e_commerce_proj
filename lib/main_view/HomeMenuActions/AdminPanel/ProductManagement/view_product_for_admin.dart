import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:flutter/material.dart';

import '../UserManagement/view_user_detail.dart';

class ViewProductInfo extends StatefulWidget {
  final Item item;

  const ViewProductInfo({super.key, required this.item});

  @override
  State<ViewProductInfo> createState() => _ViewProductInfoState();
}

class _ViewProductInfoState extends State<ViewProductInfo> {
  late Item _item;

  @override
  void initState() {
    _item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.productName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductInfo(item: _item),
        ],
      ),
    );
  }
}

class ProductInfo extends StatefulWidget {
  const ProductInfo({
    super.key,
    required Item item,
  }) : _item = item;

  final Item _item;

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ItemCRUD().readByProductId(int.parse(widget._item.productId)),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data != null) {
              final item = snapshot.data!;
              return _buildContent(item, context);
            } else if (snapshot.hasError) {
              return ItemNameTwo(itemName: snapshot.error.toString());
            } else {
              return const Center(
                child: Text('Unexpected error occurred'),
              );
            }
          default:
            return const LinearProgressIndicator();
        }
      },
    );
  }

  Widget _buildContent(Item item, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            height: 250,
            width: 250,
            child: Image.network(item.productImage),
          ),
        ),
        ItemNameTwo(itemName: 'Product ID : ${item.productId}'),
        ItemNameTwo(itemName: 'Product Name : ${item.productName}'),
        ItemNameTwo(
            itemName: 'Product Category : ${item.productCategory}'),
        ItemNameTwo(itemName: 'Description : ${item.description}'),
        ItemNameTwo(itemName: 'Price : ₹${item.productPrice}'),
        Row(
          children: [
            ItemNameTwo(
              itemName:
                  'Approval : ${int.parse(item.productStatus) == 1 ? 'Approved' : 'Not approved'}',
            ),
            Switch(
              value: int.parse(item.productStatus) == 1 ? true : false,
              onChanged: (value) {
                ItemCRUD().updateProductStatus(
                  int.parse(item.productId),
                  value,
                  (message) {
                    onSuccess(context, message, () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    });
                  },
                  (error) {
                    onError(context, error);
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
