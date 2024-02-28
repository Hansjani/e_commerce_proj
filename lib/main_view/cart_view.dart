// ignore_for_file: avoid_print

import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
import 'package:e_commerce_ui_1/cart/cart_provider.dart';
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
                if (cartItems.isEmpty) {
                  return const SizedBox();
                } else {
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
                                  cartProvider.removeAtIndexInCart(index);
                                });
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                          AddOrRemoveOne(
                            itemIndex: index,
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, billRoute);
          },
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}

class AddOrRemoveOne extends StatelessWidget {
  const AddOrRemoveOne({super.key, required this.itemIndex});

  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.cartList.isEmpty ||
            itemIndex < 0 ||
            itemIndex >= cartProvider.cartList.length) {
          return const SizedBox(); // Return an empty container if cartList is empty or itemIndex is out of range
        } else {
          final int itemQuantity = cartProvider.cartList[itemIndex].itemQuantity;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () {
                  if (itemQuantity >= 1) {
                    cartProvider.decreaseItemQuantity(itemIndex);
                  }
                },
                child: const Text('-'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  onPressed: () {},
                  child: Text(itemQuantity.toString()),
                ),
              ),
              FilledButton(
                onPressed: () {
                  cartProvider.increaseItemQuantity(itemIndex);
                },
                child: const Text('+'),
              ),
            ],
          );
        }
      },
    );
  }
}

