import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_carousel_slider_api.dart';
import 'package:flutter/material.dart';

import 'slider_image_list.dart';

class AppSliderList extends StatefulWidget {
  const AppSliderList({super.key});

  @override
  State<AppSliderList> createState() => _AppSliderListState();
}

class _AppSliderListState extends State<AppSliderList> {
  late Future<List<SliderInfo>> _sliderList;

  @override
  void initState() {
    _sliderList = SliderAPI().getSliders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Sliders'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _sliderList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SliderInfo> sliders = snapshot.data!;
            if (sliders.isNotEmpty) {
              return ListView.builder(
                itemCount: sliders.length,
                itemBuilder: (context, index) {
                  SliderInfo slider = sliders[index];
                  return ListTile(
                    leading: Text(slider.sliderId!),
                    title: Text(slider.sliderName!),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AppSliderImagesList(
                              sliderId: int.parse(slider.sliderId!));
                        },
                      ));
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No items available'),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error : ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
