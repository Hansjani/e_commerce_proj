import 'package:flutter/foundation.dart';

class CartItem {
  final int productId;
  int productQuantity;
  final String? username;

  CartItem({
    required this.productId,
    this.productQuantity = 1,
    required this.username,
  });
}

class CartItemProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int cartItemIndex(CartItem cartItem) {
    return _cartItems.indexOf(cartItem);
  }

  int getIndexById(int productId) {
    if (isInCart(productId)) {
      return _cartItems
          .indexWhere((cartItem) => cartItem.productId == productId);
    } else {
      return -1;
    }
  }

  void increaseQuantity(CartItem cartItem) {
    if (!isInCart(cartItem.productId)) {
      addToCart(cartItem);
    } else {
      int index = cartItemIndex(cartItem);
      if (index >= 0) {
        cartItem.productQuantity += 1;
      }
    }
    notifyListeners();
  }

  void decreaseQuantity(CartItem cartItem) {
    if (isInCart(cartItem.productId)) {
      int index = cartItemIndex(cartItem);
      if (index >= 0) {
        cartItem.productQuantity -= 1;
      }
    }
    notifyListeners();
  }

  void addToCart(CartItem cartItem) {
    if (!isInCart(cartItem.productId)) {
      _cartItems.add(cartItem);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((cartItem) => cartItem.productId == productId);
    notifyListeners();
  }

  bool isInCart(int cartItemId) {
    return _cartItems.any((cartItem) => cartItem.productId == cartItemId);
  }
}
