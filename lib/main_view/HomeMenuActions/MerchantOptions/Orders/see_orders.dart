import 'package:e_commerce_ui_1/APIs/OrderAPI/see_orders.dart';
import 'package:flutter/material.dart';

class AllOrdersForCompany extends StatelessWidget {
  const AllOrdersForCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All orders'),
      ),
      body: FutureBuilder(
        future: OrderForMerchantAPI().getOrderDetails(2, 'admin'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            OrderForUser orderForUser = snapshot.data!;
            return ListTile(
              title: Text('OrderID : ${orderForUser.orderId}'),
            );
          }
        },
      ),
    );
  }
}
