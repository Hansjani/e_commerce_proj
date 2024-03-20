import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/main_view/Categories/category_item_view.dart';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          return ListView.builder(
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
                              builder: (context) => CategoryItemView(
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
                                'Quantity : ${cartItem.productQuantity.toString()}'),
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
