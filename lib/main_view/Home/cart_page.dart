import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/APIs/UserAPI/cart_api.dart';
import 'package:e_commerce_ui_1/main_view/Categories/category_item_view.dart';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';

class MainCartPage extends StatelessWidget {
  const MainCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartItemProvider>(
      builder: (context, cartItemProvider, child) {
        final cartItems = cartItemProvider.cartItems;
        if (cartItems.isEmpty) {
          return const Center(
            child: Text('No items in cart'),
          );
        } else {
          return Scaffold(
            body: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                CartItem cartItem = cartItems[index];
                return FutureBuilder(
                  future: ItemCRUD().readByProductId(cartItem.productId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      Item item = snapshot.data!;
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryItemView(
                                        productID: cartItem.productId),
                              ),
                            );
                          },
                          isThreeLine: true,
                          title: Text(item.productName),
                          leading: Image.network(item.productImage),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Price : ₹ ${item.productPrice}'),
                              Text(
                                  'Quantity : ${cartItem.productQuantity
                                      .toString()}'),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                cartItemProvider
                                    .removeFromCart(cartItem.productId);
                              },
                              icon: const Icon(Icons.delete)),
                        ),
                      );
                    } else {
                      return const LoadingTile();
                    }
                  },
                );
              },
            ),
            bottomNavigationBar: BottomAppBar(
              child: ElevatedButton(
                  onPressed: () {
                    List<OrderProduct> products = cartItems.map((cartItem) =>
                        OrderProduct(productId: cartItem.productId,
                            quantity: cartItem.productQuantity),)
                        .toList();
                    OrderAPI().placeOrder(
                      products,
                    ).then((value) => cartItemProvider.clearCart());
                  },
                  child: const Text('Press')),
            ),
          );
        }
      },
    );
  }
}

class LoadingTile extends StatelessWidget {
  const LoadingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white70),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,

          // SkeletonAnimation method
          children: <Widget>[
            SkeletonAnimation(
              child: Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                  child: SkeletonAnimation(
                    child: Container(
                      height: 15,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[300]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: SkeletonAnimation(
                      child: Container(
                        width: 60,
                        height: 13,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[300]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
