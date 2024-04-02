import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../../APIs/AdminActionAPI/admin_carousel_slider_api.dart';

class AppSliderImagesList extends StatefulWidget {
  final int sliderId;

  const AppSliderImagesList({super.key, required this.sliderId});

  @override
  State<AppSliderImagesList> createState() => _AppSliderImagesListState();
}

class _AppSliderImagesListState extends State<AppSliderImagesList> {
  late Future<List<SliderImages>> _sliderImages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: _sliderImages,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('no slider images available'),
                );
              } else {
                List<SliderImages> images = snapshot.data;
                List<Widget> networkImages = images.map((url) {
                  return Image.network(url.imageUrl!);
                }).toList();
                if (networkImages.isNotEmpty) {
                  return CarouselSlider(
                    items: networkImages,
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: false,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No images for slider'),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
