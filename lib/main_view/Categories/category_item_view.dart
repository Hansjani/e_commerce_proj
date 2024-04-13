import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_carousel_slider_api.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/APIs/ProductAPI/product_feedback.dart';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/item_ratings_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/wishlist_provider.dart';
import 'package:e_commerce_ui_1/shop_items_logic/shop_items_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryItemView extends StatefulWidget {
  final int productID;

  const CategoryItemView({
    super.key,
    required this.productID,
  });

  @override
  State<CategoryItemView> createState() => _CategoryItemViewState();
}

class _CategoryItemViewState extends State<CategoryItemView> {
  late Future<Item> itemFuture;
  late Future<List<SliderImages>> _itemSliderImages;
  IconData wishIcon = Icons.favorite_border;
  bool _isImageFetched = false;
  late Future<String?> _username;

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? prefsUsername = prefs.getString(PrefsKeys.userName);
    if (prefsUsername == null) {
      return null;
    } else {
      return prefsUsername;
    }
  }

  @override
  void initState() {
    _username = _getUsername();
    itemFuture = ItemCRUD().readByProductId(widget.productID);
    super.initState();
  }

  @override
  void dispose() {
    itemFuture;
    super.dispose();
  }

  void toggle(bool isWished) {
    wishIcon = isWished ? Icons.favorite : Icons.favorite_border;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product View'),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(
                icon: Icon(Icons.shopping_bag),
              ),
              Tab(
                icon: Icon(Icons.feedback),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildItemPage(context, itemFuture),
            _buildFeedbackPage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDivider('Ratings for this product'),
          FutureBuilder(
            future: ProductFeedbackAPI().ratingsOfProduct(widget.productID),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                List<int>? ratings = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingsChartBar(ratingList: ratings),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('waiting...');
              } else if (snapshot.data == null) {
                return const Text('No rating available for this product');
              } else {
                return const Text('Uncaught exception');
              }
            },
          ),
          _buildDivider('Your feedback'),
          CommentsSection(
            productId: widget.productID,
            commentFunction: () {
              _updateComment(context, widget.productID);
            },
            futureUsername: _username,
            userUpdate: () {
              _updateComment(
                context,
                widget.productID,
              );
            },
            customDivider: _buildDivider('All app feedbacks'),
          ),
        ],
      ),
    );
  }

  Widget _buildItemPage(BuildContext context, Future<Item> itemFuture) {
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
    return FutureBuilder(
      future: itemFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final item = snapshot.data!;
          _itemSliderImages =
              SliderAPI().getVisibleSliderImage(int.parse(item.productSlider));
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
                              child:
                                  Text('No images are available for this item'),
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
              ],
            ),
          );
        }
      },
    );
  }

  void _updateComment(BuildContext context, int productId) async {
    final UserFeedbackProvider feedbackProvider =
        Provider.of(context, listen: false);
    UserFeedback? feedback = feedbackProvider.getUserFeedback(productId);
    log(feedback.comment);
    final TextEditingController updateFeedbackController =
        TextEditingController(text: feedback.comment);
    int selectedRating = feedback.rating;

    showDialog(
      context: context,
      builder: (context) {
        bool isSubmitting = false;
        String? message;

        return StatefulBuilder(
          builder: (context, setState) {
            void submitFeedback(int rating, String comment) {
              setState(() => isSubmitting = true);
              try {
                ProductFeedbackAPI().submitFeedback(
                  rating,
                  comment,
                  productId,
                  (successMessage) {
                    setState(() {
                      message = successMessage;
                      isSubmitting = false;
                    });
                  },
                  (errorMessage) {
                    message = errorMessage;
                    isSubmitting = false;
                  },
                );
                feedbackProvider.updateFeedback(
                  feedback.productId,
                  comment,
                  rating,
                );
              } catch (e) {
                setState(() {
                  isSubmitting = false;
                  message = "Failed to submit or update feedback.";
                });
              }
            }

            return AlertDialog(
              title: const Text('Update feedback'),
              content: isSubmitting
                  ? const CircularProgressIndicator()
                  : message != null
                      ? Text(message!)
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              minLines: 5,
                              maxLines: 10,
                              controller: updateFeedbackController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  gapPadding: 4,
                                ),
                              ),
                              keyboardType: TextInputType.multiline,
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    selectedRating = index + 1;
                                  }),
                                  child: Icon(
                                    index < selectedRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 24.0,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
              actions: <Widget>[
                if (!isSubmitting && message == null)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                if (!isSubmitting && message == null)
                  TextButton(
                    onPressed: () {
                      submitFeedback(
                        selectedRating,
                        updateFeedbackController.text,
                      );
                    },
                    child: const Text('Update'),
                  ),
                if (message != null)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDivider(String dividerString) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dividerString,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
