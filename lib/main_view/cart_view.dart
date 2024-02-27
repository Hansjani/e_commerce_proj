// ignore_for_file: avoid_print

import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
import 'package:e_commerce_ui_1/cart/cart_provider.dart';
import 'package:e_commerce_ui_1/cart/cart_toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final cartItems = cartProvider.cartList;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(cartItem.cartTitle),
                          subtitle: Text('INR ${cartItem.itemPrice}'),
                          leading: SizedBox(
                            height: 55,
                            width: 55,
                            child: Image(
                              image: cartItem.cartImage,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                int cartIndex =
                                    cartProvider.getIndexOfCartItem(cartItem);
                                print('index $cartIndex');
                                if (cartIndex != -1) {
                                  cartProvider.cartList.removeAt(cartIndex);
                                }
                                print(CartUtil().isInCart.toString());
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                        const AddOrRemoveOne(),
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
          onPressed: (){
            Navigator.pushNamed(context, billRoute);
          },
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}

class AddOrRemoveOne extends StatefulWidget {
  const AddOrRemoveOne({super.key});

  @override
  State<AddOrRemoveOne> createState() => _AddOrRemoveOneState();
}

class _AddOrRemoveOneState extends State<AddOrRemoveOne> {

  int currentNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton(
          onPressed: () {
            setState(() {
              if(currentNumber > 1){
                currentNumber--;
              }
            });
          },
          child: const Text('-'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            onPressed: () {},
            child: Text(currentNumber.toString()),
          ),
        ),
        FilledButton(
          onPressed: () {
            setState(() {
              currentNumber++;
            });
          },
          child: const Text('+'),
        ),
      ],
    );
  }
}

