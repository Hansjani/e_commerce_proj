import 'package:e_commerce_ui_1/main_view/cart_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class ItemImage extends StatelessWidget {
  const ItemImage({super.key, required this.itemImage});

  final ImageProvider itemImage;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: itemImage,
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
      child: Text(
        itemName,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ItemPriceAndWishlist extends StatefulWidget {
  final String itemPrice;
  final VoidCallback wishlistFunction;
  final IconData wishlistIcon;

  const ItemPriceAndWishlist(
      {super.key,
      required this.itemPrice,
      required this.wishlistFunction,
      required this.wishlistIcon});

  @override
  State<ItemPriceAndWishlist> createState() => _ItemPriceAndWishlistState();
}

class _ItemPriceAndWishlistState extends State<ItemPriceAndWishlist> {
  int number = 0;

  void add() {
    setState(() {
      number = number + 1;
    });
  }

  void minus() {
    setState(() {
      if (number >= 1) {
        number = number - 1;
      } else {
        number = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    devtools.log('build : $number');
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              widget.itemPrice,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '+      ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      add();
                    },
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: number.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: '      -',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      minus();
                    },
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: widget.wishlistFunction,
            icon: Icon(widget.wishlistIcon),
          ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Text(
            itemDescription,
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
  });

  final VoidCallback cartFunction;
  final IconData cartIcon;
  final int itemIndex;

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
        AddOrRemoveOne(itemIndex: itemIndex),
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
