import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/Orders/pending_orders.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/Orders/see_orders.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/Products/merchant_products.dart';
import 'package:flutter/material.dart';

class MerchantOptions extends StatelessWidget {
  const MerchantOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Options'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllOrdersForCompany(),
                ),
              );
            },
            title: const Text('Orders'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PendingOrders(),
                ),
              );
            },
            title: const Text('Pending Orders'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantProducts(),
                ),
              );
            },
            title: const Text('Products'),
          ),
        ],
      ),
    );
  }
}
