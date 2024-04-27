import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/SharedPreferences/key_names.dart';
import '../../Constants/placeholders.dart';

class Wishlist {
  final int productId;
  final String title;
  final String imageUrl;
  final String? username;

  Wishlist({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'imageUrl': imageUrl,
      'username': username,
    };
  }
}

class WishlistProvider with ChangeNotifier {
  Uri baseUrl = Uri.parse(
      'http://${PlaceHolderImages.ip}/app_db/Rgistered_user_actions/wishlist_management/wishlist_api.php');

  final List<Wishlist> _wishlist = [];

  List<Wishlist> get wishlist => _wishlist;

  int wishIndex(Wishlist wishlist) {
    return _wishlist.indexOf(wishlist);
  }

  Future<void> fetchWishlist(String token) async {
    try {
      String encodeToken = Uri.encodeComponent(token);
      Uri finalUrl = baseUrl.resolve('?token=$encodeToken');
      final response = await http.get(
        finalUrl,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['wishlistItems'];
        final String username = jsonDecode(response.body)['username'];
        for (var item in data) {
          String productName = item['productName'];
          String productImage = item['productImage'];
          int productId = item['productId'];

          Wishlist wishlistItem = Wishlist(
            title: productName,
            imageUrl: productImage,
            username: username,
            productId: productId,
          );
          addWish(wishlistItem);
        }
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void addWish(Wishlist wishlist) {
    if (!isWished(wishlist.title)) {
      _wishlist.add(wishlist);
    }
    notifyListeners();
  }

  void removeWishAtIndex(Wishlist wishlist) {
    _wishlist.removeAt(wishIndex(wishlist));
    notifyListeners();
  }

  void removeWishByName(String wishName) {
    _wishlist.removeWhere((wishItem) => wishItem.title == wishName);
    notifyListeners();
  }

  bool isWished(String wishName) {
    return _wishlist.any((wishlist) => wishlist.title == wishName);
  }

  Future<void> initWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstInit = prefs.getBool(PrefsKeys.firstWishInit) ?? true;
    String? token = prefs.getString(PrefsKeys.userToken);
    String? username = prefs.getString(PrefsKeys.userName);
    if (firstInit && username != null && token != null) {
      await fetchWishlist(token);
      prefs.setBool(PrefsKeys.firstWishInit, false);
    } else {
      await loadWishlistData();
    }
    notifyListeners();
  }

  Future<void> storeWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson =
        jsonEncode(_wishlist.map((wishlist) => wishlist.toJson()).toList());
    await prefs.setString(PrefsKeys.wishlist, wishlistJson);
  }

  Future<void> loadWishlistData() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = prefs.getString(PrefsKeys.wishlist);
    if (wishlistJson != null) {
      final List<dynamic> wishlistList = jsonDecode(wishlistJson);
      _wishlist.clear();
      for (var item in wishlistList) {
        final Wishlist wishlist = Wishlist(
          productId: item['productId'],
          title: item['title'],
          imageUrl: item['imageUrl'],
          username: item['username'],
        );
        addWish(wishlist);
      }
      notifyListeners();
    }
  }

  Future<void> syncWithDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);

    if (token != null) {
      List<int> productIdList =
          _wishlist.map((wishlist) => wishlist.productId).toList();
      Map<String, dynamic> requestBody = {
        "token": token,
        "wishlistItems": productIdList,
      };

      String jsonRequestBody = jsonEncode(requestBody);
      Uri finalUrl = Uri.parse(
          'http://${PlaceHolderImages.ip}/app_db/Rgistered_user_actions/wishlist_management/sync_with_database.php');
      final response = await http.post(
        finalUrl,
        body: jsonRequestBody,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        String jsonResponse = jsonDecode(response.body)['message'];
        log(jsonResponse);
      } else {
        String jsonResponse = jsonDecode(response.body)['error'];
        log(jsonResponse);
      }
    }
  }

  @override
  void dispose() {
    syncWithDatabase();
    super.dispose();
  }
}
