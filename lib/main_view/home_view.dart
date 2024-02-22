import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/Constants/routes/routes.dart';
import 'package:e_commerce/Constants/shop_item_images.dart';
import 'package:e_commerce/main_view/home_page.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
              childAspectRatio: 1,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, tubRoute);
                    },
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: Image(
                            image: buyTub,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Ice-Cream Tubs',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, barRoute);
                    },
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: Image(
                            image: buyBar,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Ice-Cream Bar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, coneRoute);
                    },
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: Image(
                            image: buySquareCoe,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Ice-Cream Cone',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16,),
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, bookListRoute);
                    },
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: Image(
                            image: buyCup,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Ice-Cream Cup',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )
                      ],
                    ),
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
