import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

class SliderInfo {
  final String? sliderId;
  final String? sliderStatus;
  final String? sliderName;

  SliderInfo({
    required this.sliderId,
    required this.sliderStatus,
    required this.sliderName,
  });

  factory SliderInfo.fromJson(Map<String, dynamic> json) {
    return SliderInfo(
      sliderId: json['sliderId'].toString(),
      sliderStatus: json['sliderStatus'].toString(),
      sliderName: json['sliderName'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sliderId': sliderId,
      'sliderStatus': sliderStatus,
      'sliderName': sliderName,
    };
  }
}

class SliderImages {
  final String? imageId;
  final String sliderId;
  final String? imageUrl;
  final String? imageStatus;

  SliderImages(
      {required this.imageId,
        required this.sliderId,
        required this.imageUrl,
        required this.imageStatus});

  factory SliderImages.fromJson(Map<String, dynamic> json) {
    return SliderImages(
      imageId: json['imageId'].toString(),
      sliderId: json['sliderId'].toString(),
      imageUrl: json['imageUrl'].toString(),
      imageStatus: json['imageStatus'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageId': imageId,
      'sliderId': sliderId,
      'imageUrl': imageUrl,
      'imageStatus': imageStatus,
    };
  }
}

class SliderAPI {
  Uri baseUrl = Uri.parse('http://192.168.29.184/app_db/Admin_actions/slider/');

  Future<void> createSlider(
      SliderInfo sliderInfo,
      void Function(String?) success,
      void Function(String?) error,
      ) async {
    String jsonRequestBody = jsonEncode(sliderInfo.toJson);
    Uri finalUrl = baseUrl.resolve('slider_add.php');
    final response = await http.post(
      finalUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonRequestBody,
    );
    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body)['message'];
      success(jsonResponse);
    } else {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    }
  }

  Future<void> addImageToSlider(
      int sliderId,
      SliderImages sliderImages,
      void Function(String?) success,
      void Function(String?) error,
      ) async {
    String jsonRequestBody = jsonEncode(sliderImages.toJson());
    Uri finalUrl = baseUrl.resolve('slider_image_add.php');
    final response = await http.post(
      finalUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonRequestBody,
    );
    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body)['message'];
      success(jsonResponse);
    } else {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    }
  }

  Future<List<SliderInfo>> getSliders() async {
    Uri finalUrl = baseUrl.resolve('slider_get.php');
    final response = await http.get(finalUrl);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<SliderInfo> allSliders =
      jsonData.map((sliders) => SliderInfo.fromJson(sliders)).toList();
      return allSliders;
    } else {
      throw Exception("Error");
    }
  }

  Future<List<SliderImages>> getSliderImage(int sliderId) async {
    Uri finalUrl = baseUrl.resolve('slider_get.php?sliderId=$sliderId');
    final response = await http.get(finalUrl);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<SliderImages> allSliderImages =
      jsonData.map((images) => SliderImages.fromJson(images)).toList();
      allSliderImages
          .where((image) => int.parse(image.imageStatus!) == 0)
          .toList();
      return allSliderImages;
    } else {
      throw Exception("Error");
    }
  }

  Future<List<SliderImages>> getVisibleSliderImage(int sliderId) async {
    Uri finalUrl = baseUrl.resolve('slider_get.php?sliderId=$sliderId');
    final response = await http.get(finalUrl);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<SliderImages> allSliderImages =
      jsonData.map((images) => SliderImages.fromJson(images)).toList();
      List<SliderImages> visibleImages = allSliderImages
          .where((image) => int.parse(image.imageStatus!) == 0)
          .toList();
      return visibleImages;
    } else {
      throw Exception("Error");
    }
  }

  Future<void> deleteSlider(
      int sliderId,
      void Function(String) success,
      void Function(String) error,
      ) async {
    Uri finalUrl = baseUrl.resolve('slider_delete.php');
    final response = await http.delete(
      finalUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"sliderId": sliderId}),
    );
    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body)['message'];
      success(jsonResponse);
    } else if (response.statusCode == 400) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else if (response.statusCode == 500) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else {
      devtools.log(response.body);
      error(response.statusCode.toString());
    }
  }

  Future<void> deleteSliderImage(
      int imageId,
      void Function(String) success,
      void Function(String) error,
      ) async {
    Uri finalUrl = baseUrl.resolve('slider_image_delete.php');
    final response = await http.delete(
      finalUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"imageId": imageId}),
    );
    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body)['message'];
      success(jsonResponse);
    } else if (response.statusCode == 400) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else if (response.statusCode == 500) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else {
      devtools.log(response.body);
      error(response.statusCode.toString());
    }
  }
}
