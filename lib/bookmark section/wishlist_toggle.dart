// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'wishlist_manager.dart';

class WishListUtil extends ChangeNotifier {
  bool _isContains = false;

  void wishlistToggle({
    required BuildContext context,
    required String wishlistString,
    required ImageProvider wishlistImage,
  }) {
    WishListProvider wishlistProvider =
        Provider.of<WishListProvider>(context, listen: false);
    _isContains = wishlistProvider.containsWishlist(wishlistString);

    if (_isContains) {
      wishlistProvider.wishlist
          .removeWhere((wishlist) => wishlist.title == wishlistString);
      print('removed wish');
      _isContains = false;
    } else {
      final WishList wishlist = WishList(
        title: wishlistString,
        wishlistImage: wishlistImage,
      );
      wishlistProvider.addBookmark(wishlist);
      print('added wish');
      _isContains = true;
    }
    notifyListeners();
  }

  bool get isContained => _isContains;

  void available() {
    bool isAvailable = _isContains;
    if (isAvailable) {
      print('Inside');
    } else {
      print('Outside');
    }
    notifyListeners();
  }
}
