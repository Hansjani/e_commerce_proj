import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../APIs/ProductAPI/product_image_api.dart';

class AddProductImages extends StatefulWidget {
  const AddProductImages({super.key});

  @override
  State<AddProductImages> createState() => _AddProductImagesState();
}

class _AddProductImagesState extends State<AddProductImages> {
  late int _sliderId;
  late int _productId;
  List<String> imagePaths = [];
  String mainImagePath = '';

  void getSliderId() async {
    final prefs = await SharedPreferences.getInstance();
    _sliderId = prefs.getInt(PrefsKeys.sliderId)!;
    _productId = prefs.getInt(PrefsKeys.productId)!;
  }

  @override
  void initState() {
    getSliderId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add images'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    AddProductImage.pickMultipleImages().then((path) {
                      setState(() {
                        imagePaths = path;
                      });
                    });
                  },
                  child: const Text('Select Product Images')),
              SizedBox(
                width: 300,
                height: 300,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.network(imagePaths[index]),
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    AddProductImage.pickMainImage().then((path) {
                      setState(() {
                        mainImagePath = path;
                      });
                    });
                  },
                  child: const Text('Select Main Image')),
              SizedBox(
                width: 300,
                height: 300,
                child: Image.network(mainImagePath),
              ),
              ElevatedButton(
                  onPressed: () {
                    AddProductImage()
                        .sendImagesToSlider(imagePaths, _sliderId, _productId);
                    AddProductImage()
                        .uploadMainImageOfProduct(_productId, mainImagePath)
                        .then((value) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, mainPageRoute, (route) => false);
                    });
                  },
                  child: const Text('Add Images')),
            ],
          ),
        ),
      ),
    );
  }
}
