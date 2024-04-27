import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/placeholders.dart';

class UserFeedback {
  final int productId;
  final String username;
  final String comment;
  final int rating;

  UserFeedback({
    required this.productId,
    required this.username,
    required this.comment,
    required this.rating,
  });
}

class UserFeedbackProvider with ChangeNotifier {
  final List<UserFeedback> _feedbackList = [];

  List<UserFeedback> get feedbackList => _feedbackList;

  int indexOfUserFeedback(int productId) {
    return _feedbackList
        .indexWhere((userFeedback) => userFeedback.productId == productId);
  }

  bool isInList(int productId) {
    return _feedbackList.any((feedback) => feedback.productId == productId);
  }

  UserFeedback getUserFeedback(int productId) {
    if (isInList(productId)) {
      UserFeedback userFeedback = _feedbackList.singleWhere(
        (element) => element.productId == productId,
      );
      return userFeedback;
    } else {
      return UserFeedback(
        productId: productId,
        username: _getUsername(productId),
        comment: '',
        rating: 0,
      );
    }
  }

  void initFeedback(String? username) async {
    if (username != null) {
      Uri url = Uri.parse(
          'http://${PlaceHolderImages.ip}/app_db/Seller_actions/item_management/item_feedback.php?username=$username');
      final response = await get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> jsonFeedbackList = jsonResponse['feedback'];
        List<UserFeedback> feedback = jsonFeedbackList.map((tmpFeed) {
          return UserFeedback(
            productId: tmpFeed['productId'],
            username: tmpFeed['username'],
            comment: tmpFeed['comment'],
            rating: tmpFeed['rating'],
          );
        }).toList();
        for (UserFeedback userFeedback in feedback) {
          if (!isInList(userFeedback.productId)) {
            _feedbackList.add(userFeedback);
          }
        }
        log('init feedback');
        notifyListeners();
      } else {
        log(jsonDecode(response.body)['error']);
      }
    }
  }

  String _getUsername(int productId) {
    int index =
        _feedbackList.indexWhere((element) => element.productId == productId);
    if (index != -1) {
      UserFeedback feedback = _feedbackList[index];
      String username = feedback.username;
      return username;
    } else {
      return '';
    }
  }

  void updateFeedback(int productId, String newComment, int newRating) async {
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(PrefsKeys.userName) ?? '';
    int index =
        _feedbackList.indexWhere((element) => element.productId == productId);
    if (index != -1) {
      UserFeedback newFeedback = UserFeedback(
        productId: productId,
        username: username,
        comment: newComment,
        rating: newRating,
      );
      _feedbackList[index] = newFeedback;
    } else {
      addNewFeedback(
        productId,
        UserFeedback(
          productId: productId,
          username: username,
          comment: newComment,
          rating: newRating,
        ),
      );
    }
    notifyListeners();
  }

  void addNewFeedback(int productId, UserFeedback feedback) {
    if (!isInList(productId)) {
      _feedbackList.add(feedback);
    }
    notifyListeners();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(PrefsKeys.userName);
    bool firstInit = prefs.getBool(PrefsKeys.firstFeedbackInit) ?? false;
    List<UserFeedback> feedbacks = _feedbackList
        .where((feedback) => feedback.username == username)
        .toList();
    if (username != null && !firstInit) {
      initFeedback(username);
      await prefs.setBool(PrefsKeys.firstFeedbackInit, true);
    } else if (username != null && feedbacks.isEmpty && firstInit) {
      initFeedback(username);
    }
    notifyListeners();
  }
}
