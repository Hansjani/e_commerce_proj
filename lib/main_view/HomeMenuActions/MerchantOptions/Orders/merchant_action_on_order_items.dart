import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/APIs/OrderAPI/see_orders.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/Orders/see_orders.dart';
import 'package:flutter/material.dart';

import '../../../../Constants/placeholders.dart';

class OrderActionByMerchant extends StatelessWidget {
  final List<OrderItemForOrder> orderItems;
  final int orderId;

  const OrderActionByMerchant(
      {super.key, required this.orderItems, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #$orderId"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const AllOrdersForCompany()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          OrderItemForOrder orderItem = orderItems[index];
          return ListTile(
            leading: Container(
              decoration: BoxDecoration(border: Border.all()),
              height: 100,
              width: 100,
              child: Image.network(
                orderItem.imageUrl ?? PlaceHolderImages.itemPlaceholder,
                fit: BoxFit.fill,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ItemID : #${orderItem.orderItemId}'),
                Text('ProductID : #${orderItem.productId}'),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order quantity : ${orderItem.quantity}'),
                Text('Order item price : ${orderItem.price}'),
                DropdownButton<String>(
                  value: orderItem.status,
                  items: orderItemStatus
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    OrderForMerchantAPI().updateOrderItemStatus(
                      orderItem.orderId,
                      orderItem.orderItemId,
                      value!,
                      (message) {
                        onSuccess(context, message, () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllOrdersForCompany(),
                            ),
                            (route) => false,
                          );
                        });
                      },
                      (error) {
                        onException(context, error, () {
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

List<String> orderItemStatus = [
  'pending_check',
  'not_available',
  'available',
  'sent',
];
