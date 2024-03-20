// import 'package:flutter/material.dart';
//
// class WishList {
//   final String title;
//   final ImageProvider wishlistImage;
//
//   WishList({required this.title, required this.wishlistImage});
//
// }
//
// class WishListProvider extends ChangeNotifier {
//   final List<WishList> _wishlists = [];
//
//   List<WishList> get wishlist => _wishlists;
//
//   int getIndexOfBookmark(WishList wishlist) {
//     return _wishlists.indexOf(wishlist);
//   }
//
//   void addBookmark(WishList wishlist) {
//     _wishlists.add(wishlist);
//     notifyListeners();
//   }
//
//   void removeBookmark(WishList wishlist) {
//     _wishlists.remove(wishlist);
//     notifyListeners();
//   }
//
//   bool containsWishlist(String wishlistTitle){
//     return _wishlists.any((wishlist) => wishlist.title == wishlistTitle);
//   }
// }
