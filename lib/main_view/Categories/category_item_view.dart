import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_carousel_slider_api.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/APIs/ProductAPI/product_feedback.dart';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/wishlist_provider.dart';
import 'package:e_commerce_ui_1/shop_items_logic/shop_items_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryItemView extends StatefulWidget {
  final int productID;

  const CategoryItemView({super.key, required this.productID,});

  @override
  State<CategoryItemView> createState() => _CategoryItemViewState();
}

class _CategoryItemViewState extends State<CategoryItemView> {
  late Future<Item> itemFuture;
  late Future<List<SliderImages>> _itemSliderImages;
  IconData wishIcon = Icons.favorite_border;
  bool _isImageFetched = false;

  @override
  void initState() {
    super.initState();
    itemFuture = ItemCRUD().readByProductId(widget.productID);
  }

  void toggle(bool isWished) {
    wishIcon = isWished ? Icons.favorite : Icons.favorite_border;
  }

  @override
  Widget build(BuildContext context) {
    final wishProvider = Provider.of<WishlistProvider>(context, listen: false);
    final userAuth = Provider.of<AuthProvider>(context, listen: false);
    final cartItemProvider =
        Provider.of<CartItemProvider>(context, listen: false);
    final existingIndex = cartItemProvider.getIndexById(widget.productID);
    CartItem cartItem;
    if (existingIndex == -1) {
      cartItem = CartItem(
          productId: widget.productID,
          username: userAuth.currentUser?.username);
    } else {
      cartItem = cartItemProvider.cartItems[existingIndex];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Item'),
      ),
      body: FutureBuilder(
        future: itemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final item = snapshot.data!;
            _itemSliderImages = SliderAPI()
                .getVisibleSliderImage(int.parse(item.productSlider));
            bool isWished = wishProvider.isWished(item.productName);
            toggle(isWished);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    height: 300,
                    width: 350,
                    child: Card(
                      elevation: 4,
                      color: Colors.grey,
                      child: FutureBuilder(
                        future: _itemSliderImages,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (!_isImageFetched) {
                              _isImageFetched = true;
                            }
                            List<SliderImages> images = snapshot.data!;
                            List<Widget> sliderImages = images.map((url) {
                              return Image.network(
                                url.imageUrl!,
                                fit: BoxFit.fill,
                              );
                            }).toList();
                            if (sliderImages.isNotEmpty) {
                              return CarouselSlider(
                                items: sliderImages,
                                options: CarouselOptions(
                                    autoPlay: false,
                                    aspectRatio: 1,
                                    viewportFraction: 1),
                              );
                            } else {
                              return const Center(
                                child: Text(
                                    'No images are available for this item'),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('${snapshot.error}'),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  ItemName(itemName: item.productName),
                  ItemPriceAndWishlist(
                    itemPrice: '₹ ${item.productPrice}',
                    wishlistFunction: () {
                      if (isWished) {
                        wishProvider.removeWishByName(item.productName);
                        wishProvider.storeWishlist();
                      } else {
                        wishProvider.addWish(
                          Wishlist(
                              productId: int.parse(item.productId),
                              title: item.productName,
                              imageUrl: item.productImage,
                              username: userAuth.currentUser?.username),
                        );
                        wishProvider.storeWishlist();
                      }
                      setState(() {});
                    },
                    wishlistIcon: wishIcon,
                  ),
                  ItemDescription(itemDescription: item.description),
                  Center(
                      child: NewItemCart(
                          productId: widget.productID, cartItem: cartItem)),
                  ItemBuy(
                    buyFunction: () {},
                  ),
                  const ItemSectionDivider(),
                  FutureRatings(widget: widget),
                  CommentsSection(productId: widget.productID),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class FutureRatings extends StatelessWidget {
  const FutureRatings({
    super.key,
    required this.widget,
  });

  final CategoryItemView widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          ProductFeedbackAPI().ratingsOfProduct(widget.productID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          List<int>? ratings = snapshot.data!;
          return RatingsChartBar(ratingList: ratings);
        } else if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Text('waiting...');
        } else if (snapshot.data == null) {
          return const Text(
              'No rating available for this product');
        } else {
          return const Text('Uncaught exception');
        }
      },
    );
  }
}

class ItemSectionDivider extends StatelessWidget {
  const ItemSectionDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 10,
              ),
              child: const Divider(),
            ),
          ),
          RichText(
            text: const TextSpan(
              text: 'Feedback Section',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 20,
              ),
              child: const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
