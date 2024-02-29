import 'package:e_commerce_ui_1/cart/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as devtools show log;

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
      devtools.log('removed from cart');
      _isInCart = false;
      notifyListeners();
    } else {
      final Cart cart = Cart(
          cartTitle: cartItemTitle,
          cartImage: cartImage,
          itemPrice: cartItemPrice);
      cartProvider.addToCart(cart);
      devtools.log('added to cart');
      _isInCart = true;
      notifyListeners();
    }
    notifyListeners();
  }

  bool get isInCart => _isInCart;

  void cartItem() {
    bool isCartItem = _isInCart;
    if (isCartItem) {
      devtools.log('Cart Item');
    } else {
      devtools.log('Not a cart item');
    }
  }
}
