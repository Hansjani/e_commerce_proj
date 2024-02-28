import 'package:e_commerce_ui_1/bookmark%20section/wishlist_manager.dart';
import 'package:e_commerce_ui_1/cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constants/item_name.dart';
import '../../Constants/shop_item_images.dart';
import '../../bookmark section/wishlist_toggle.dart';
import '../../shop_items_logic/shop_items_logic.dart';

class TheChosenBook extends StatefulWidget {
  const TheChosenBook({super.key});

  @override
  State<TheChosenBook> createState() => _TheChosenBookState();
}

class _TheChosenBookState extends State<TheChosenBook> {
  @override
  Widget build(BuildContext context) {
    print('Build');
    bool _isInList = Provider.of<WishListProvider>(context, listen: false)
        .containsWishlist(theBook);
    bool _isInCart =
        Provider.of<CartProvider>(context).containItemInCart(theBook);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Item'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ItemImage(itemImage: showBook),
            const ItemName(
              itemName: theBook,
            ),
            ItemPriceAndWishlist(
              wishlistIcon: _isInList ? Icons.favorite : Icons.favorite_border,
              itemPrice: '54 INR',
              wishlistFunction: () {
                setState(() {
                  Provider.of<WishListUtil>(context, listen: false)
                      .wishlistToggle(
                    context: context,
                    wishlistString: theBook,
                    wishlistImage: showBook,
                  );
                });
                Provider.of<WishListUtil>(context, listen: false).available();
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
              cartFunction: () {
                var cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                Cart cartItem = Cart(
                  cartTitle: theBook,
                  cartImage: showBook,
                  itemPrice: 54,
                );
                cartProvider.addToCart(cartItem);
                setState(() {});
              },
              cartIcon: _isInCart
                  ? Icons.remove_shopping_cart
                  : Icons.add_shopping_cart_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
