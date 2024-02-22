import 'package:e_commerce/Constants/item_name.dart';
import 'package:e_commerce/Constants/shop_item_images.dart';
import 'package:e_commerce/bookmark%20section/bookmark_toggle.dart';
import 'package:e_commerce/shop_items_logic/shop_items_logic.dart';
import 'package:flutter/material.dart';

class StrawberryIceCreamCup extends StatefulWidget {
  const StrawberryIceCreamCup({super.key});

  @override
  State<StrawberryIceCreamCup> createState() => _StrawberryIceCreamCupState();
}

class _StrawberryIceCreamCupState extends State<StrawberryIceCreamCup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(theStrawberryCup),
      ),
      body: Column(
        children: [
          ItemImage(itemImage: strawberryCup,),
          const ItemName(itemName: theStrawberryCup,),
          ItemPriceAndBookmark(itemPrice: '50 INR', bookmarkFunction: () {
            setState(() {
              bookmarkToggle(context: context, bookmarkString: theStrawberryCup, bookmarkImage: strawberryCup,);
            });
          }, bookmarkIcon: bookmarkToggleIcon,),
          const ItemDescription(itemDescription: "Strawberry ice cream is a flavor of ice cream made with strawberry or strawberry flavoring."
              " It is made by blending in fresh strawberries or strawberry flavoring with the eggs,"
              " cream, vanilla, and sugar used to make ice cream. "
              "Most strawberry ice cream is colored pink or light red.",),
          ItemBuyAndCart(buyFunction: (){}, cartFunction: () {},),

        ],
      ),
    );
  }
}
