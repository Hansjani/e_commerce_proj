import 'dart:convert';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class AddProductImage{

  static Future<List<String>> pickMultipleImages() async {
    List<String> imagePaths = [];
    List<XFile>? images = await ImagePicker().pickMultiImage();

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://192.168.29.184/app_db/Seller_actions/item_management/upload_image.php'));
    for (var image in images) {
      var multipartFile =
      await http.MultipartFile.fromPath('files[]', image.path);
      request.files.add(multipartFile);
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);
      List<dynamic> urls = data['urls'];
      imagePaths.addAll(urls.map((url) => url.toString()));
      return imagePaths;
    } else {
      throw Exception('Failed to upload images: ${response.reasonPhrase}');
    }
  }

  static Future<String> pickMainImage() async {
    String imagePath = '';
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://192.168.29.184/app_db/Seller_actions/item_management/update_image.php'),
    );
    var multipartFile = await http.MultipartFile.fromPath('file', image!.path);
    request.files.add(multipartFile);
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      String url = data['url'];
      imagePath = url;
      log(imagePath);
      return imagePath;
    } else {
      throw Exception('Failed to upload image : ${response.reasonPhrase}');
    }
  }

  Future<void> sendImagesToSlider(
      List<String> urls, int sliderId, int productId) async {
    Map<String, dynamic> requestBody = {
      "sliderId": sliderId,
      "productId": productId,
      "urls": urls,
    };
    String requestJsonBody = jsonEncode(requestBody);
    final response = await http.post(
      Uri.parse(
          'http://192.168.29.184/app_db/Seller_actions/item_management/upload_to_slider.php'),
      body: requestJsonBody,
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body)['message'];
      log(jsonResponse);
    } else {
      String jsonResponse = jsonDecode(response.body)['error'];
      log(jsonResponse);
    }
  }

  Future<void> uploadMainImageOfProduct(int productId, String url) async {
    Map<String, dynamic> requestBody = {
      "productId": productId,
      "url": url,
    };
    String requestJsonBody = jsonEncode(requestBody);
    final response = await http.post(
      Uri.parse(
          'http://192.168.29.184/app_db/Seller_actions/item_management/upload_main_image.php'),
      body: requestJsonBody,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body)['message'];
      log(jsonResponse);
    } else {
      String jsonResponse = jsonDecode(response.body)['error'];
      log(jsonResponse);
    }
  }
}