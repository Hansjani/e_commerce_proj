import 'package:flutter/cupertino.dart';

class Cart {
  final String cartTitle;
  final ImageProvider cartImage;
  final int itemPrice;

  Cart({
    required this.cartTitle,
    required this.cartImage,
    required this.itemPrice,
  });
}

class CartProvider extends ChangeNotifier {
  List<Cart> _cartList = [];

  List<Cart> get cartList => _cartList;

  int getIndexOfCartItem(Cart cart) {
    return _cartList.indexOf(cart);
  }

  void addToCart(Cart cart) {
    _cartList.add(cart);
    notifyListeners();
  }

  void removeFromCart(Cart cart) {
    _cartList.remove(cart);
    notifyListeners();
  }

  bool containItemInCart(String cartItemTitle) {
    return _cartList.any((cart) => cart.cartTitle == cartItemTitle);
  }

  int itemPriceInCart(int index) {
    if (index >= 0 && index < _cartList.length) {
      return _cartList[index].itemPrice;
    } else {
      return 0;
    }
  }
}
