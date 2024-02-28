import 'package:flutter/cupertino.dart';

class Cart {
  final String cartTitle;
  final ImageProvider cartImage;
  final int itemPrice;
  int itemQuantity;

  Cart({
    required this.cartTitle,
    required this.cartImage,
    required this.itemPrice,
    this.itemQuantity = 0,
  });
}

class CartProvider extends ChangeNotifier {
  List<Cart> _cartList = [];

  List<Cart> get cartList => _cartList;

  int getIndexOfCartItem(Cart cart) {
    return _cartList.indexOf(cart);
  }

  void addToCart(Cart cart) {
    int index = _cartList.indexWhere((item) => item.cartTitle == cart.cartTitle);
    if(index != -1){
      _cartList[index].itemQuantity += 1;
    }else{
      _cartList.add(cart);
    }
    notifyListeners();
  }

  void removeFromCart(Cart cart) {
    int index = _cartList.indexWhere((item) => item.cartTitle == cart.cartTitle);
    if(index != -1){
      if(cartList[index].itemQuantity > 1){
        _cartList[index].itemQuantity -= 1;
      } else {
        _cartList.remove(cart);
      }
    }
    notifyListeners();
  }

  void removeAtIndexInCart(int index){
    if(index >= 0 && index < _cartList.length){
      _cartList.removeAt(index);
    }
    notifyListeners();
  }

  void decreaseItemQuantity(int index) {
    if (index >= 0 && index < _cartList.length) {
      _cartList[index].itemQuantity -= 1;
      notifyListeners();
    }
  }

  void increaseItemQuantity(int index) {
    if (index >= 0 && index < _cartList.length) {
      _cartList[index].itemQuantity += 1;
      notifyListeners();
    }
  }

  void removeWhereTitle(String cartItemTitle){
    _cartList.removeWhere((cart) => cart.cartTitle == cartItemTitle);
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
