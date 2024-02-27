import 'package:e_commerce_ui_1/cart/cart_provider.dart';
import 'package:e_commerce_ui_1/main_view/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillView extends StatelessWidget {
  const BillView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final billItems = cartProvider.cartList;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: billItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final billItem = billItems[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(billItem.cartTitle),
                          trailing: Text('INR ${billItem.itemPrice}'),
                          // subtitle: Text('Number of current item : $'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {},
          child: Consumer<CartProvider>(
            builder: (BuildContext context, CartProvider cartProvider,
                Widget? child) {
              int totalBill = 0;
              for (int i = 0 ;i < cartProvider.cartList.length ; i++){
                totalBill += cartProvider.cartList[i].itemPrice;
              }
              return Text('Pay INR $totalBill');
            },
          ),
        ),
      ),
    );
  }
}
