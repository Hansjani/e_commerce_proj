import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../Constants/routes/routes.dart';
import '../Constants/shop_item_images.dart';
import 'home_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              items: carouselItems,
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                aspectRatio: 16 / 19,
              ),
            ),
            GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Image(
                          image: buyLaptop,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Laptops',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Image(
                          image: buySmartphone,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Smartphones',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Image(
                          image: buyHomeAplliances,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Home Appliances',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16,),
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, bookListRoute);
                  },
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.6,
                        child: Image(
                          image: buyBooks,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Books',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
