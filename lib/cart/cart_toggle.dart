// ignore_for_file: avoid_print

import 'package:e_commerce_ui_1/cart/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartUtil extends ChangeNotifier {
  bool _isInCart = false;

  void cartItemToggle({
    required BuildContext context,
    required String cartItemTitle,
    required ImageProvider cartImage,
    required int cartItemPrice,
  }) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    _isInCart = cartProvider.containItemInCart(cartItemTitle);

    if (_isInCart) {
      cartProvider.removeWhereTitle(cartItemTitle);
      print('removed from cart');
      _isInCart = false;
      notifyListeners();
    } else {
      final Cart cart = Cart(
          cartTitle: cartItemTitle,
          cartImage: cartImage,
          itemPrice: cartItemPrice);
      cartProvider.addToCart(cart);
      print('added to cart');
      _isInCart = true;
      notifyListeners();
    }
    notifyListeners();
  }

  bool get isInCart => _isInCart;

  void cartItem() {
    bool isCartItem = _isInCart;
    if (isCartItem) {
      print('Cart Item');
    } else {
      print('Not a cart item');
    }
  }
}
