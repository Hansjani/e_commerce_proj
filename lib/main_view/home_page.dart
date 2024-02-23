import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_ui_1/main_view/photoitems_logic/phot_items.dart';
import 'package:flutter/material.dart';
import '../Constants/routes/routes.dart';
import '../Constants/shop_item_images.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              carouselController: _controller,
              items: carouselItems,
              options: CarouselOptions(
                autoPlay: false,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                aspectRatio: 1.3,
                viewportFraction: 0.9,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: carouselItems.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.2),
                    ),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                padding: const EdgeInsets.all(8),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                crossAxisCount: 2,
                children: [
                  PhotoItems(
                    imageDescription: 'Phones',
                    photoImage: buySmartphone,
                    navigationFunction: () {},
                  ),
                  PhotoItems(
                    imageDescription: 'Laptops',
                    photoImage: buyLaptop,
                    navigationFunction: () {},
                  ),
                  PhotoItems(
                    imageDescription: 'Home Appliances',
                    photoImage: buyHomeAplliances,
                    navigationFunction: () {},
                  ),
                  PhotoItems(
                    imageDescription: 'Books',
                    photoImage: booksMain,
                    navigationFunction: () =>
                        Navigator.pushNamed(context, bookListRoute),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> carouselItems = [
  Image(
    image: bookOne,
    fit: BoxFit.fill,
  ),
  Image(
    image: buyBooks,
    fit: BoxFit.fill,
  ),
  Image(
    image: buyHomeAplliances,
    fit: BoxFit.fill,
  ),
  Image(
    image: buyLaptop,
    fit: BoxFit.fill,
  ),
  Image(
    image: buySmartphone,
    fit: BoxFit.fill,
  ),
];
