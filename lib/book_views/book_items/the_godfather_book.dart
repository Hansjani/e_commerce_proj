import 'package:flutter/material.dart';

import '../../Constants/item_name.dart';
import '../../Constants/shop_item_images.dart';
import '../../bookmark section/bookmark_toggle.dart';
import '../../shop_items_logic/shop_items_logic.dart';

class TheGodfatherBook extends StatefulWidget {
  const TheGodfatherBook({super.key});

  @override
  State<TheGodfatherBook> createState() => _TheGodfatherBookState();
}

class _TheGodfatherBookState extends State<TheGodfatherBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(theGodfather),
      ),
      body: Column(
        children: [
          ItemImage(itemImage: bookOne),
          const ItemName(
            itemName: theGodfather,
          ),
          ItemPriceAndBookmark(
            bookmarkIcon: bookmarkToggleIcon,
            itemPrice: '543 INR',
            bookmarkFunction: () {
              setState(() {
                bookmarkToggle(
                  context: (context),
                  bookmarkString: theGodfather,
                  bookmarkImage: bookOne,
                );
              });
            },
          ),
          const ItemDescription(
              itemDescription:
                  "The Godfather is a crime novel by American author Mario Puzo."
                  " Originally published in 1969 by G. P. Putnam's Sons, "
                  "the novel details the story of a fictional Mafia family in New York City (and Long Island), "
                  "headed by Vito Corleone, the Godfather."
                  " The novel covers the years 1945 to 1955 and includes the back story of Vito Corleone from early childhood to adulthood."
                  "The first in a series of novels, "
                  "The Godfather is noteworthy for introducing Italian words like consigliere, caporegime, Cosa Nostra, and omertà to an English-speaking audience. "
                  "It inspired a 1972 film of the same name. Two film sequels, including new contributions by Puzo himself, were made in 1974 and 1990."),
          ItemBuyAndCart(
            buyFunction: () {},
            cartFunction: () {},
          ),
        ],
      ),
    );
  }
}
