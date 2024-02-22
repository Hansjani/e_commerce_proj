import 'package:e_commerce/Constants/item_name.dart';
import 'package:e_commerce/Constants/shop_item_images.dart';
import 'package:e_commerce/bookmark%20section/bookmark_toggle.dart';
import 'package:e_commerce/shop_items_logic/shop_items_logic.dart';
import 'package:flutter/material.dart';

class VanillaIceCreamCup extends StatefulWidget {
  const VanillaIceCreamCup({super.key});

  @override
  State<VanillaIceCreamCup> createState() => _VanillaIceCreamCupState();
}

class _VanillaIceCreamCupState extends State<VanillaIceCreamCup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(theVanillaCup),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ItemImage(itemImage: vanillaCup),
            const ItemName(itemName: 'Vanilla Ice Cream'),
            ItemPriceAndBookmark(
              itemPrice: '45 INR',
              bookmarkFunction: () {
                setState(() {
                  bookmarkToggle(
                    context: context,
                    bookmarkString: theVanillaCup,
                    bookmarkImage: vanillaCup,
                  );
                });
              },
              bookmarkIcon: bookmarkToggleIcon,
            ),
            const ItemDescription(
              itemDescription: "Vanilla ice cream is the most common and basic flavour of ice cream which is favourite amongst all."
                  " Vanilla ice cream is made by blending in vanilla essence in along with the eggs (optional)"
                  ", cream, milk and sugar."
                  " The vanilla essence added gives the ice cream a very natural aroma and vanilla flavour.",
            ),
            ItemBuyAndCart(
              buyFunction: () {},
              cartFunction: () {},
            ),
          ],
        ),
      ),
    );
  }
}
