import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Item {
  final String productId;
  final String productName;
  final String description;
  final String provider;
  final String productPrice;
  final String productStock;
  final String productCategory;
  final String productSlider;
  final String productImage;

  Item(
      {required this.productId,
      required this.productName,
      required this.description,
      required this.provider,
      required this.productPrice,
      required this.productStock,
      required this.productCategory,
      required this.productSlider,
      required this.productImage});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json['productId'].toString(),
      productName: json['productName'],
      description: json['description'],
      productPrice: json['price'].toString(),
      productStock: json['stockQuantity'].toString(),
      productCategory: json['catagoryId'].toString(),
      provider: json['provider'],
      productSlider: json['productSlider'].toString(),
      productImage: json['productImage'],
    );
  }
}

class ItemCRUD {
  Uri baseUrl =
      Uri.parse('http://192.168.29.184/app_db/Seller_actions/item_management/');

  Future<List<Item>> readItem(int categoryId) async {
    Uri finalUrl = baseUrl.resolve('item_read.php?categoryId=$categoryId');
    final response = await http.get(
      finalUrl,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Item.fromJson(item)).toList();
    } else {
      log(finalUrl.toString());
      log(response.body);
      throw Exception('Failed to load users');
    }
  }

  Future<Item> readByProductId(int productId) async {
    Uri finalUrl = baseUrl.resolve('read_by_id.php?productId=$productId');
    final response = await http.get(
      finalUrl,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      Map<String, dynamic> itemData = jsonData[0];
      return Item.fromJson(itemData);
    } else {
      log(finalUrl.toString());
      log(response.body);
      throw Exception('Failed to load users');
    }
  }

  Future<List<Item>> readByProductProvider(String? company) async {
    Uri finalUrl = baseUrl.resolve('read_by_provider.php?provider=$company');
    final response = await http.get(
      finalUrl,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Item.fromJson(item)).toList();
    } else {
      log(finalUrl.toString());
      log(response.body);
      throw Exception('Failed to load users');
    }
  }

  Future<String?> pickUpdateImage(int? productId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      if (file.existsSync()) {
        Future<String?> url = uploadUpdateImage(file, productId);
        return url;
      } else {
        log('file does not exist');
      }
    }
    return null;
  }

  Future<String?> uploadUpdateImage(File file, int? productId) async {
    Uri finalUrl = baseUrl.resolve('update_image.php');
    final request = http.MultipartRequest('POST', finalUrl);
    request.fields['productId'] = jsonEncode({"productId": productId});
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      if (jsonResponse.containsKey('message') &&
          jsonResponse.containsKey('url')) {
        return jsonResponse['url'];
      }
    } else if (response.statusCode == 400) {
      String jsonResponse = jsonDecode(responseBody)['error'];
      return jsonResponse;
    } else if (response.statusCode == 405) {
      String jsonResponse = jsonDecode(responseBody)['error'];
      return jsonResponse;
    } else if (response.statusCode == 409) {
      String jsonResponse = jsonDecode(responseBody)['error'];
      return jsonResponse;
    } else if (response.statusCode == 500) {
      String jsonResponse = jsonDecode(responseBody)['error'];
      return jsonResponse;
    }
    return null;
  }

  Future<void> createItem(
    String productName,
    String description,
    double productPrice,
    int productStock,
    String productCategory,
    String company,
    void Function(String) onSuccess,
    void Function(String) onError,
  ) async {
    Map<String, dynamic> requestBody = {
      "productName": productName,
      "description": description,
      "productPrice": productPrice,
      "productStock": productStock,
      "productCategory": productCategory,
      "company": company,
    };
    String jsonRequestBody = jsonEncode(requestBody);
    Uri fullUrl = baseUrl.resolve('item_create.php');
    final response = await http.post(fullUrl,
        body: jsonRequestBody, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('message')) {
        onSuccess(jsonResponse['message']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt(PrefsKeys.sliderId, jsonResponse['sliderId']);
        await prefs.setInt(PrefsKeys.productId, jsonResponse['productId']);
      }
    } else if (response.statusCode == 405) {
      String jsonResponse = jsonDecode(response.body)['error'];
      onError(jsonResponse);
    } else if (response.statusCode == 500) {
      String jsonResponse = jsonDecode(response.body)['error'];
      onError(jsonResponse);
    } else {
      onError('Some unexpected error occurred');
    }
  }

  Future<void> updateItem(
    int productId,
    String productName,
    String description,
    double productPrice,
    int productStock,
    String productImageUrl,
    void Function(String) onSuccess,
    void Function(String) onError,
  ) async {
    Map<String, dynamic> requestBody = {
      "productId": productId,
      "productName": productName,
      "description": description,
      "productPrice": productPrice,
      "productStock": productStock,
      "productImageUrl": productImageUrl,
    };
    String jsonRequestBody = jsonEncode(requestBody);
    Uri fullUrl = baseUrl.resolve('item_update.php');
    final response = await http.post(fullUrl,
        body: jsonRequestBody, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('message')) {
        onSuccess(jsonResponse['message']);
      }
    } else if (response.statusCode == 404) {
      String jsonResponse = jsonDecode(response.body)['error'];
      onError(jsonResponse);
    } else if (response.statusCode == 405) {
      String jsonResponse = jsonDecode(response.body)['error'];
      onError(jsonResponse);
    } else if (response.statusCode == 409) {
      String jsonResponse = jsonDecode(response.body)['error'];
      onError(jsonResponse);
    } else if (response.statusCode == 500) {
      String jsonResponse = jsonDecode(response.body)['error'];
      onError(jsonResponse);
    } else {
      onError('Some unexpected error occurred');
    }
  }

  Future<void> deleteItem(
    int productId,
    void Function(String) onSuccess,
    void Function(String) onError,
  ) async {
    Map<String, dynamic> requestBody = {
      "productId": productId,
    };
    String jsonRequestBody = jsonEncode(requestBody);
    Uri fullUrl = baseUrl.resolve('item_delete.php');
    final response = await http.delete(fullUrl,
        body: jsonRequestBody, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('message')) {
        onSuccess(jsonResponse['message']);
      }
    } else if (response.statusCode == 404) {
      String jsonResponse = jsonDecode(response.body)['error'];
      onError(jsonResponse);
    } else if (response.statusCode == 405) {
      String jsonResponse = jsonDecode(response.body)['error'];
      onError(jsonResponse);
    } else if (response.statusCode == 500) {
      String jsonResponse = jsonDecode(response.body)['error'];
      onError(jsonResponse);
    } else {
      onError('Some unexpected error occurred');
    }
  }

  Future<List<String>> getCompanies() async {
    Uri finalUrl = Uri.parse(
        'http://192.168.29.184/app_db/Admin_actions/get_provider_company.php');

    try {
      final response = await http.get(finalUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> companiesJson = data['companies'];
        final List<dynamic> merchantsJson = data['merchants'];
        final List<String> merchants =
            merchantsJson.map((e) => e.toString()).toList();
        final List<String> companies =
            companiesJson.map((e) => e.toString()).toList();
        final List<String> provider = [];
        for (int i = 0; i < merchants.length; i++) {
          provider.add('${merchants[i]} -- ${companies[i]}');
        }
        return provider;
      } else {
        throw Exception('Failed to load companies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load companies: $e');
    }
  }
}

void onError(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error!'),
        content: Text(error),
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

void onSuccess(BuildContext context, String message, void Function() success) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: success,
            child: const Text('ok'),
          ),
        ],
      );
    },
  );
}
