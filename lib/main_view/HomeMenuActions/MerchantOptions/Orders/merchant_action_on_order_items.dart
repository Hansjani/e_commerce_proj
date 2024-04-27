import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/APIs/OrderAPI/see_orders.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/Orders/see_orders.dart';
import 'package:flutter/material.dart';

import '../../../../Constants/placeholders.dart';

class OrderActionByMerchant extends StatefulWidget {
  final List<OrderItemForOrder> orderItems;
  final int orderId;
  final String company;

  const OrderActionByMerchant(
      {super.key,
      required this.orderItems,
      required this.orderId,
      required this.company});

  @override
  State<OrderActionByMerchant> createState() => _OrderActionByMerchantState();
}

class _OrderActionByMerchantState extends State<OrderActionByMerchant> {
  bool _isLoading = false;
  late final Future<List<OrderItemForOrder>?> items;
  late final Future<OrderItemForOrder?> item;
  late final Future<Item> product;

  void getOrderItemForOrder() async {}

  @override
  void initState() {
    items = OrderForMerchantAPI().getOrderItems(widget.company);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Order #${widget.orderId}"),
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
            itemCount: widget.orderItems.length,
            itemBuilder: (context, index) {
              OrderItemForOrder orderItemFromWidget = widget.orderItems[index];
              return FutureBuilder(
                future: Future.wait([
                  ItemCRUD().readByProductId(orderItemFromWidget.productId),
                  OrderForMerchantAPI().getOrderItemDetails(
                    orderItemFromWidget.orderItemId,
                    orderItemFromWidget.orderId,
                    widget.company,
                  ),
                ]),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        Item? item = snapshot.data?[0] as Item?;
                        OrderItemForOrder? orderItem =
                            snapshot.data?[1] as OrderItemForOrder?;
                        if (item != null && orderItem != null) {
                          return ListTile(
                            leading: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              height: 100,
                              width: 100,
                              child: Image.network(
                                orderItem.imageUrl ??
                                    PlaceHolderImages.itemPlaceholder,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Order ItemID : #${orderItem.orderItemId}'),
                                Text('ProductID : #${orderItem.productId}'),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Available Quantity : ${item.productStock}'),
                                Text('Order quantity : ${orderItem.quantity}'),
                                Text('Order item price : ${orderItem.price}'),
                                DropdownButton<String>(
                                  value: orderItem.status,
                                  items: orderItemStatus
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    merchantAction(orderItem, value, context);
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text('No item for this order'),
                          );
                        }
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('${snapshot.error}'),
                          );
                        } else {
                          return Center(
                            child: Text(
                              'data : ${snapshot.data} \n conn : ${snapshot.connectionState} \n stack : ${snapshot.stackTrace} \n snapshot : $snapshot',
                            ),
                          );
                        }
                      }
                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },
              );
            },
          ),
        ),
        if (_isLoading)
          ModalBarrier(
            color: Colors.black.withOpacity(0.5),
            dismissible: false,
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  void merchantAction(
      OrderItemForOrder orderItem, String? value, BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await OrderForMerchantAPI().updateOrderItemStatus(
      orderItem.orderId,
      orderItem.orderItemId,
      value!,
      (message) {
        onSuccess(context, message, () {
          Navigator.pop(context);
        });
      },
      (error) {
        onException(context, error, () {
          Navigator.pop(context);
        });
      },
    );
    setState(() {
      _isLoading = false;
    });
  }
}

List<String> orderItemStatus = [
  'pending_check',
  'not_available',
  'available',
  'sent',
];
