import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_carousel_slider_api.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_category_api.dart';
import 'package:e_commerce_ui_1/TEMP/web_view.dart';
import 'package:e_commerce_ui_1/main_view/Categories/category_list_view.dart';
import 'package:e_commerce_ui_1/main_view/photo_items_logic/photo_items.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  late Future<List<ProductCategory>> _futureCategory;
  late Future<List<SliderImages>> _mainPageSlider;
  late final ValueNotifier<int> _currentIndexNotifier;

  @override
  void initState() {
    _futureCategory = ProductCategoryAPI().getCategories();
    _mainPageSlider = SliderAPI().getVisibleSliderImage(24);
    _currentIndexNotifier = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_futureCategory, _mainPageSlider]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<ProductCategory>? categories =
              snapshot.data![0].cast<ProductCategory>();
          List<SliderImages> images = snapshot.data![1].cast<SliderImages>();
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 1),
                      child: Column(
                        children: [
                          CarouselSlider(
                            items: images
                                .map((url) => Image.network(url.imageUrl!))
                                .toList(),
                            options: CarouselOptions(
                              viewportFraction: 0.95,
                              enlargeCenterPage: true,
                              height: 300,
                              onPageChanged: (index, reason) {
                                _currentIndexNotifier.value = index;
                              },
                            ),
                            carouselController: _carouselController,
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: _currentIndexNotifier,
                            builder: (context, currentIndex, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: images.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () => _carouselController
                                        .animateToPage(entry.key),
                                    child: CarouselIndicator(
                                        index: entry.key,
                                        currentIndex:
                                            _currentIndexNotifier.value),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 375,
                  width: 375,
                  child: GridView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      ProductCategory category = categories[index];
                      return Card(
                        child: PhotoItems(
                          imageDescription: category.categoryName,
                          photoImage: category.categoryImage,
                          navigationFunction: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return CategoryListView(
                                  categoryId: int.parse(
                                    category.categoryId,
                                  ),
                                  categoryName: category.categoryName,
                                );
                              },
                            ));
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: SizedBox(
                          width: 70,
                          child: Image.network(
                              'https://ishtexim.com/public/images/product/Hot%20&%20Spicy-01_11zon.webp'),
                        ),
                        title: const Text('Hot & Spicy Flavour Noodles'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ItemWebView(
                                  url: 'https://ishtexim.com/productDetail/85',
                                  title: 'Hot & Spicy Flavour Noodles',),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: SizedBox(
                          width: 70,
                          child: Image.network(
                              'https://ishtexim.com/public/images/product/Shrimp-01_11zon.webp'),
                        ),
                        title: const Text('Shrimp Flavour Noodles'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ItemWebView(
                                url: 'https://ishtexim.com/productDetail/86',
                                title: 'Shrimp Flavour Noodles',),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: SizedBox(
                          width: 70,
                          child: Image.network(
                              'https://ishtexim.com/public/images/product/Veggie-01__11zon.webp'),
                        ),
                        title: const Text('Veggie Flavour Noodles'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ItemWebView(
                                url: 'https://ishtexim.com/productDetail/87',
                                title: 'Veggie Flavour Noodles',),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}

class CarouselIndicator extends StatelessWidget {
  final int index;
  final int currentIndex;

  const CarouselIndicator({
    Key? key,
    required this.index,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == currentIndex;
    return Opacity(
      opacity: isSelected ? 0.9 : 0.4,
      child: Container(
        height: 12,
        width: 12,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
