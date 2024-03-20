// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:developer' as devtools show log;
// import '../../Constants/item_name.dart';
// import '../../Constants/shop_item_images.dart';
// import '../../bookmark section/wishlist_manager.dart';
// import '../../bookmark section/wishlist_toggle.dart';
// import '../../cart/cart_provider.dart';
// import '../../shop_items_logic/shop_items_logic.dart';
//
// class TestBook extends StatefulWidget {
//   const TestBook({Key? key}) : super(key: key);
//
//   @override
//   State<TestBook> createState() => _TestBookState();
// }
//
// int _itemQuantityTwo = 0;
//
// class _TestBookState extends State<TestBook> {
//   @override
//   Widget build(BuildContext context) {
//     devtools.log('Build');
//     bool isInList = Provider.of<WishListProvider>(context, listen: false)
//         .containsWishlist(testBook);
//     bool isInCart =
//         Provider.of<CartProvider>(context).containItemInCart(testBook);
//     CartProvider cartProvider =
//         Provider.of<CartProvider>(context, listen: false);
//     Cart? cartItem = isInCart
//         ? cartProvider.cartList.firstWhere((item) => item.cartTitle == testBook)
//         : null;
//     int cartIndex =
//         cartItem != null ? cartProvider.getIndexOfCartItem(cartItem) : -1;
//     int itemQuantity = cartItem?.itemQuantity ?? 0;
//     devtools.log(_itemQuantityTwo.toString());
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book Item'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Image(image: showLaptop),
//             const ItemName(
//               itemName: testBook,
//             ),
//             ItemPriceAndWishlist(
//               wishlistIcon: isInList ? Icons.favorite : Icons.favorite_border,
//               itemPrice: '1234 INR',
//               wishlistFunction: () {
//                 setState(() {
//                   Provider.of<WishListUtil>(context, listen: false)
//                       .wishlistToggle(
//                     context: context,
//                     wishlistString: testBook,
//                     wishlistImage: showLaptop,
//                   );
//                 });
//                 Provider.of<WishListUtil>(context, listen: false).available();
//               },
//             ),
//             const ItemDescription(
//                 itemDescription:
//                     "The Godfather is a crime novel by American author Mario Puzo."
//                     " Originally published in 1969 by G. P. Putnam's Sons, "
//                     "the novel details the story of a fictional Mafia family in New York City (and Long Island), "
//                     "headed by Vito Corleone, the Godfather."
//                     " The novel covers the years 1945 to 1955 and includes the back story of Vito Corleone from early childhood to adulthood."
//                     "The first in a series of novels, "
//                     "The Godfather is noteworthy for introducing Italian words like consigliere, caporegime, Cosa Nostra, and omertà to an English-speaking audience. "
//                     "It inspired a 1972 film of the same name. Two film sequels, including new contributions by Puzo himself, were made in 1974 and 1990."),
//             ItemCart(
//               cartFunction: () {
//                 if (isInCart) {
//                   print('Item is already in the cart');
//                   print('Item quantity in cart: $itemQuantity');
//                 } else {
//                   var cartProvider =
//                       Provider.of<CartProvider>(context, listen: false);
//                   Cart cartItem = Cart(
//                     cartTitle: testBook,
//                     cartImage: showLaptop,
//                     itemPrice: 1234,
//                   );
//                   cartProvider.setItemQuantity(cartItem, _itemQuantityTwo);
//                   setState(() {});
//                 }
//               },
//               cartIcon: isInCart
//                   ? Icons.remove_shopping_cart
//                   : Icons.add_shopping_cart_rounded,
//               itemIndex: cartIndex,
//               itemQuantity: _itemQuantityTwo,
//               itemMinus: () {
//                 setState(() {
//                   _itemQuantityTwo -= 1;
//                 });
//               },
//               itemPlus: () {
//                 setState(() {
//                   _itemQuantityTwo += 1;
//                 });
//               },
//             ),
//             ItemBuy(
//               buyFunction: () {
//
//               },
//             ),
//             // AddOrRemoveItemTwo(itemIndex: cartIndex),
//           ],
//         ),
//       ),
//     );
//   }
// }
