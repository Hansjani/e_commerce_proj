import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Constants/placeholders.dart';

class ProductCategory {
  final String categoryId;
  final String categoryName;
  final String categoryStatus;
  final String categoryImage;

  ProductCategory(
      {required this.categoryId,
        required this.categoryName,
        required this.categoryStatus,
        required this.categoryImage});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      categoryId: json['id'].toString(),
      categoryName: json['catagroyName'],
      categoryStatus: json['catagoryStatus'].toString(),
      categoryImage: json['catagoryImageUrl'],
    );
  }

  Map<String,dynamic> toJson() {
    return {
      "id" : categoryId,
      "catagroyName" : categoryName,
      "catagoryStatus" : categoryStatus,
      "catagoryImageUrl" : categoryImage,
    };
  }
}

class ProductCategoryAPI {
  Uri baseUrl = Uri.parse('http://${PlaceHolderImages.ip}/app_db/Products/category/categories_get.php');

  Future<List<ProductCategory>> getCategories() async {
    Uri finalUrl = baseUrl.resolve('');
    final response = await http.get(finalUrl);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      if(jsonData.isNotEmpty){
        List<ProductCategory> allCategories = jsonData.map((category) => ProductCategory.fromJson(category)).toList();
        List<ProductCategory> visibleCategories = allCategories.where((category) => int.parse(category.categoryStatus) == 0).toList();
        return visibleCategories;
      }else{
        throw Exception('Empty response');
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
