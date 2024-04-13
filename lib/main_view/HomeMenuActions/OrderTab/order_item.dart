import 'package:e_commerce_ui_1/APIs/UserAPI/cart_api.dart';
import 'package:flutter/material.dart';
import '../../../APIs/AdminActionAPI/item_management_api.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order : #${order.orderId}'),
      ),
      body: FutureBuilder(
        future: OrderAPI().getOrderItems(order.orderId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<OrderProduct> orderItems = snapshot.data!;
            return Align(
              alignment: Alignment.topCenter,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: orderItems.length,
                        itemBuilder: (context, index) {
                          final orderItem = orderItems[index];
                          return FutureBuilder(
                            future:
                                ItemCRUD().readByProductId(orderItem.productId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('${snapshot.error}'),
                                );
                              } else if (snapshot.hasData) {
                                Item item = snapshot.data!;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                              item.productName),
                                          SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Image.network(
                                                item.productImage),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Price : ${item.productPrice}'),
                                            Text(
                                                'Quantity : ${orderItem.quantity}'),
                                            Text(
                                                'Total : ${orderItem.quantity * double.parse(item.productPrice)}'),
                                          ],
                                        ),
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
                          );
                        },
                      ),
                      Text('Order status = ${order.status}'),
                      Text('Grand Total = ${order.amount}'),
                    ],
                  ),
                ),
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
}
