import 'dart:convert';
import 'dart:developer';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductFeedback {
  final int rating;
  final String comment;
  final String username;

  ProductFeedback(
      {required this.rating, required this.comment, required this.username});

  factory ProductFeedback.fromJson(Map<String, dynamic> json) {
    return ProductFeedback(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      username: json['username'],
    );
  }
}

class ProductFeedbackAPI {
  Uri baseUrl =
      Uri.parse('http://192.168.29.184/app_db/Seller_actions/item_management/');

  Future<void> submitFeedback(
    int rating,
    String comment,
    int productId,
    void Function(String) success,
    void Function(String) error,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    if (token != null) {
      try {
        Uri url = baseUrl.resolve('item_feedback.php');
        Map<String, dynamic> requestBody = {
          "token": token,
          "rating": rating,
          "comment": comment,
          "productId": productId,
        };
        String jsonRequestBody = jsonEncode(requestBody);
        final response = await http.post(url,
            headers: {"Content-Type": "application/json"},
            body: jsonRequestBody);
        print(response.body);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          String message = jsonResponse['message'];
          success(message);
        } else {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          String errorMessage = jsonResponse['error'];
          error(errorMessage);
        }
      } catch (e) {
        throw Exception(e);
      }
    }else{
      throw Exception('Please login first');
    }
  }

  Future<double> getRatings(int productId) async {
    Uri finalUrl = baseUrl.resolve('item_feedback.php?product_id=$productId');
    final response = await http.get(
      finalUrl,
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      Map<String,dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic>? responseList = jsonResponse['feedback'];
      if(responseList == null){
        return 0;
      }
      List<int>? ratings = responseList.map((feedback){
        return feedback['rating'] as int;
      }).toList();
      double totalRating = 0;
      for (var feedback in ratings) {
        totalRating += feedback;
      }
      double avgRating = totalRating / ratings.length;
      return avgRating;
    } else {
      throw Exception();
    }
  }

  Future<List<int>?> ratingsOfProduct(int productId) async {
    Uri finalUrl = baseUrl.resolve('item_feedback.php?product_id=$productId');
    final response = await http.get(
      finalUrl,
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      Map<String,dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic>? jsonResponseList = jsonResponse['feedback'];
      if(jsonResponseList == null){
        return null;
      }
      List<int>? ratings = jsonResponseList.map((feedback) {
        return feedback['rating'] as int;
      }).toList();
      return ratings;
    } else {
      throw Exception();
    }
  }

  Future<List<ProductFeedback>?> commentsOfProduct(int productId) async {
    Uri finalUrl = baseUrl.resolve('item_feedback.php?product_id=$productId');
    final response = await http.get(
      finalUrl,
      headers: {
        "Content-Type": "application/json",
      },
    );
    log(response.body);
    if (response.statusCode == 200) {
      List<dynamic>? feedbackJson = jsonDecode(response.body)['feedback'];
      if (feedbackJson == null) {
        return null;
      }
      List<ProductFeedback> feedbackList = feedbackJson.map((feedbackData) {
        return ProductFeedback(
          rating: feedbackData['rating'],
          comment: feedbackData['comment'],
          username: feedbackData['username'],
        );
      }).toList();
      return feedbackList;
    } else {
      throw Exception();
    }
  }
}

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    Key? key,
    required this.rating,
    this.starSize = 24.0,
    this.starColor = Colors.amber,
  }) : super(key: key);

  final double rating;
  final double starSize;
  final Color starColor;

  @override
  Widget build(BuildContext context) {
    final int fullStars = rating.floor();
    final bool hasHalfStar = rating - fullStars >= 0.5;
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(
            Icons.star,
            size: starSize,
            color: starColor,
          );
        } else if (index == fullStars && hasHalfStar) {
          return Icon(
            Icons.star_half,
            size: starSize,
            color: starColor,
          );
        } else {
          return Icon(
            Icons.star_border,
            size: starSize,
            color: starColor,
          );
        }
      }),
    );
  }
}

void feedbackThankYou(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Submitted successfully'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ok'),
          ),
        ],
      );
    },
  );
}
