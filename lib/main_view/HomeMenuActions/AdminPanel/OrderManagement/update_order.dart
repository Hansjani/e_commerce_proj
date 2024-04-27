import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_order_action_api.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/APIs/OrderAPI/see_orders.dart';
import 'package:e_commerce_ui_1/APIs/UserAPI/cart_api.dart';
import 'package:e_commerce_ui_1/main_view/Home/cart_page.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/AdminPanel/OrderManagement/all_orders_list.dart';
import 'package:flutter/material.dart';

class UpdateOrderStatus extends StatefulWidget {
  final OrdersForAdmin ordersForAdmin;

  const UpdateOrderStatus({super.key, required this.ordersForAdmin});

  @override
  State<UpdateOrderStatus> createState() => _UpdateOrderStatusState();
}

class _UpdateOrderStatusState extends State<UpdateOrderStatus> {
  late Future<List<OrderProduct>> orderProduct;

  @override
  void initState() {
    orderProduct = OrderAPI().getOrderItems(widget.ordersForAdmin.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AllOrderList(),
              ),
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Order Details'),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: orderProduct,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: LinearProgressIndicator(),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List<OrderProduct> orderProducts = snapshot.data!;
                        if (orderProducts.isEmpty) {
                          return const Center(
                            child: Text('No orders found'),
                          );
                        } else {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderProducts.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                future: ItemCRUD().readByProductId(
                                  orderProducts[index].productId,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('${snapshot.error}'),
                                    );
                                  } else if (snapshot.hasData) {
                                    if (snapshot.data != null) {
                                      Item item = snapshot.data!;
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              left: BorderSide(),
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text('Product ${index + 1}'),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ProductID : ${item.productId}',
                                                ),
                                                Text(
                                                  'Product name : ${item.productName}',
                                                ),
                                                Text(
                                                  'Status : ${orderProducts[index].status}',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: Text('No items found'),
                                      );
                                    }
                                  } else {
                                    return const LoadingTile();
                                  }
                                },
                              );
                            },
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      } else {
                        return const Center(
                          child: Text('No orders found'),
                        );
                      }
                    default:
                      throw Exception();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: orderProduct,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.none) {
                      return const SizedBox.shrink();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Order date : ${widget.ordersForAdmin.orderDate}'),
                            Text(
                                'Total amount : ${widget.ordersForAdmin.totalAmount}'),
                            DropdownButton(
                              value: widget.ordersForAdmin.orderStatus,
                              items: orderStatus.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                OrderForMerchantAPI().updateOrderStatus(
                                  widget.ordersForAdmin.orderId,
                                  value!,
                                  (message) {
                                    onSuccess(
                                      context,
                                      message,
                                      () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AllOrderList(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                    );
                                  },
                                  (errorMessage) {
                                    onException(context, errorMessage, () {
                                      Navigator.pop(context);
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> orderStatus = [
  'received',
  'processing',
  'cancelled',
  'pending',
  'sent'
];
