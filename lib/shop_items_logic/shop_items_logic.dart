import 'dart:developer';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cart/cart_provider.dart';

class ItemImage extends StatelessWidget {
  const ItemImage({super.key, required this.itemImage});

  final String itemImage;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      itemImage,
      fit: BoxFit.contain,
      alignment: Alignment.center,
    );
  }
}

class ItemName extends StatelessWidget {
  const ItemName({super.key, required this.itemName});

  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Item Name',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            itemName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemPriceAndWishlist extends StatelessWidget {
  final String itemPrice;
  final VoidCallback wishlistFunction;
  final IconData wishlistIcon;

  const ItemPriceAndWishlist(
      {super.key,
      required this.itemPrice,
      required this.wishlistFunction,
      required this.wishlistIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  itemPrice,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  onPressed: wishlistFunction,
                  icon: Icon(wishlistIcon),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ItemDescription extends StatelessWidget {
  const ItemDescription({super.key, required this.itemDescription});

  final String itemDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Text(
            itemDescription,
            style: TextStyle(color: Colors.grey.shade600),
            softWrap: true,
          ),
        )
      ],
    );
  }
}

class ItemCart extends StatelessWidget {
  const ItemCart({
    super.key,
    required this.cartFunction,
    required this.cartIcon,
    required this.itemIndex,
    required this.itemQuantity,
    required this.itemMinus,
    required this.itemPlus,
  });

  final VoidCallback cartFunction;
  final IconData cartIcon;
  final int itemIndex;
  final int itemQuantity;
  final VoidCallback itemMinus;
  final VoidCallback itemPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton.filled(
                onPressed: cartFunction, icon: Icon(cartIcon)),
          ),
        ),
        AddOrRemoveItem(
          itemIndex: itemIndex,
          itemPlus: itemPlus,
          itemMinus: itemMinus,
          itemQuantity: itemQuantity,
        )
      ],
    );
  }
}

class ItemBuy extends StatelessWidget {
  const ItemBuy({
    super.key,
    required this.buyFunction,
  });

  final VoidCallback buyFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FilledButton(
              onPressed: buyFunction,
              child: const Text('Buy'),
            ),
          ),
        ),
      ],
    );
  }
}

class AddOrRemoveItem extends StatelessWidget {
  const AddOrRemoveItem({
    super.key,
    required this.itemIndex,
    required this.itemQuantity,
    required this.itemMinus,
    required this.itemPlus,
  });

  final int itemIndex;
  final int itemQuantity;
  final VoidCallback itemMinus;
  final VoidCallback itemPlus;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.cartList.isEmpty ||
            itemIndex < 0 ||
            itemIndex >= cartProvider.cartList.length) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: itemMinus,
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
                onPressed: itemPlus,
                child: const Text('+'),
              ),
            ],
          );
        } else {
          final int itemQuantity =
              cartProvider.cartList[itemIndex].itemQuantity;
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

class NewItemCart extends StatefulWidget {
  final int productId;
  final CartItem cartItem;

  const NewItemCart(
      {super.key, required this.productId, required this.cartItem});

  @override
  State<NewItemCart> createState() => _NewItemCartState();
}

class _NewItemCartState extends State<NewItemCart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartItemProvider>(
      builder: (context, cartItemProvider, child) {
        bool isInside = cartItemProvider.isInCart(widget.productId);
        cartItemProvider.cartItemIndex(widget.cartItem);
        if (isInside) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if(widget.cartItem.productQuantity > 1){
                        cartItemProvider.decreaseQuantity(widget.cartItem);
                      }else{
                        cartItemProvider.removeFromCart(widget.productId);
                      }
                    },
                    child: const Text('-'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        widget.cartItem.productQuantity.toString(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      log('inc');
                      cartItemProvider.increaseQuantity(widget.cartItem);
                    },
                    child: const Text('+'),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cartItemProvider.addToCart(widget.cartItem);
                    },
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
