import 'package:flutter/material.dart';

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

class ItemPriceAndBookmark extends StatelessWidget {
  final String itemPrice;
  final VoidCallback bookmarkFunction;
  final IconData bookmarkIcon;

  const ItemPriceAndBookmark({super.key, required this.itemPrice, required this.bookmarkFunction, required this.bookmarkIcon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
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
          child: IconButton(
            onPressed: bookmarkFunction,
            icon: Icon(bookmarkIcon),
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
        Text(
          itemDescription,
          softWrap: true,
        )
      ],
    );
  }
}

class ItemBuyAndCart extends StatelessWidget {
  const ItemBuyAndCart({super.key, required this.buyFunction, required this.cartFunction});

  final VoidCallback buyFunction;
  final VoidCallback cartFunction;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: buyFunction,
                child: const Text('Buy'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton.filled(
                onPressed: cartFunction,
                icon: const Icon(Icons.add_shopping_cart),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
