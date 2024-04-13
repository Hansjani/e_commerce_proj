import 'dart:developer';
import 'package:e_commerce_ui_1/APIs/ProductAPI/product_feedback.dart';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/item_ratings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ItemImage extends StatelessWidget {
  const ItemImage({super.key, required this.itemImage});

  final String itemImage;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      itemImage,
      fit: BoxFit.contain,
      alignment: Alignment.center,
    );
  }
}

class ItemName extends StatelessWidget {
  const ItemName({super.key, required this.itemName});

  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Item Name',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            itemName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemPriceAndWishlist extends StatelessWidget {
  final String itemPrice;
  final VoidCallback wishlistFunction;
  final IconData wishlistIcon;

  const ItemPriceAndWishlist(
      {super.key,
      required this.itemPrice,
      required this.wishlistFunction,
      required this.wishlistIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  itemPrice,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  onPressed: wishlistFunction,
                  icon: Icon(wishlistIcon),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ItemDescription extends StatelessWidget {
  const ItemDescription({super.key, required this.itemDescription});

  final String itemDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Text(
            itemDescription,
            style: TextStyle(color: Colors.grey.shade600),
            softWrap: true,
          ),
        )
      ],
    );
  }
}

class ItemBuy extends StatelessWidget {
  const ItemBuy({
    super.key,
    required this.buyFunction,
  });

  final VoidCallback buyFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FilledButton(
              onPressed: buyFunction,
              child: const Text('Buy'),
            ),
          ),
        ),
      ],
    );
  }
}

class NewItemCart extends StatefulWidget {
  final int productId;
  final CartItem cartItem;

  const NewItemCart(
      {super.key, required this.productId, required this.cartItem});

  @override
  State<NewItemCart> createState() => _NewItemCartState();
}

class _NewItemCartState extends State<NewItemCart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartItemProvider>(
      builder: (context, cartItemProvider, child) {
        bool isInside = cartItemProvider.isInCart(widget.productId);
        cartItemProvider.cartItemIndex(widget.cartItem);
        if (isInside) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.cartItem.productQuantity > 1) {
                        cartItemProvider.decreaseQuantity(widget.cartItem);
                      } else {
                        cartItemProvider.removeFromCart(widget.productId);
                      }
                    },
                    child: const Text('-'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        widget.cartItem.productQuantity.toString(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      log('inc');
                      cartItemProvider.increaseQuantity(widget.cartItem);
                    },
                    child: const Text('+'),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      cartItemProvider.addToCart(widget.cartItem);
                    },
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class RatingsChartBar extends StatelessWidget {
  const RatingsChartBar({Key? key, required this.ratingList}) : super(key: key);

  final List<int> ratingList;

  Map<int, int> _calculateDistribution(List<int> ratings) {
    Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (int rating in ratings) {
      distribution[rating] = (distribution[rating] ?? 0) + 1;
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    Map<int, int> ratingDistribution = _calculateDistribution(ratingList);

    int totalRatings = ratingList.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ratingDistribution.entries.map((entry) {
        int starCount = entry.key;
        int count = entry.value;
        double percentage = (count / totalRatings);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('$starCount Stars : '),
                Text('($count / $totalRatings)'),
              ],
            ),
            const SizedBox(height: 1),
            Container(
              height: 20,
              color: Colors.blue,
              width: MediaQuery.of(context).size.width * percentage,
              margin: const EdgeInsets.only(right: 8.0),
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}

class CommentsSection extends StatelessWidget {
  const CommentsSection({
    super.key,
    required this.productId,
    this.commentFunction,
    required this.futureUsername,
    required this.userUpdate,
    this.customDivider,
  });

  final int productId;
  final VoidCallback? commentFunction;
  final Future<String?> futureUsername;
  final Widget? customDivider;

  @override
  Widget build(BuildContext context) {
    final feedbackProvider =
        Provider.of<UserFeedbackProvider>(context, listen: false);
    UserFeedback feedbackFromProvider =
        feedbackProvider.getUserFeedback(productId);
    return FutureBuilder(
      future: Future.wait(
          [ProductFeedbackAPI().commentsOfProduct(productId), futureUsername]),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              List<ProductFeedback?>? feedback =
                  snapshot.data![0] as List<ProductFeedback>?;
              if (feedback == null) {
                return Column(
                  children: [
                    _userReview(
                      context,
                      '',
                      0,
                      productId,
                      feedbackFromProvider
                    ),
                    const Center(
                      child: Text('No feedback for this product'),
                    ),
                  ],
                );
              } else {
                String username = snapshot.data![1] as String;
                ProductFeedback? userFeedback = feedback.firstWhere(
                  (feed) => feed?.username == username,
                  orElse: () => ProductFeedback(
                    rating: 0,
                    comment: '',
                    username: username,
                  ),
                );
                log(userFeedback.toString());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (userFeedback != null)
                      _userReview(
                        context,
                        userFeedback.comment,
                        userFeedback.rating,
                        productId,
                        feedbackFromProvider,
                      ),
                    customDivider ?? const SizedBox.shrink(),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: feedback.length,
                      itemBuilder: (context, index) {
                        ProductFeedback? userFeedbacks = feedback[index];
                        if (userFeedbacks == null) {
                          return const SizedBox.shrink();
                        } else {
                          return Card(
                            child: ListTile(
                              title: Text(userFeedbacks.username),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userFeedbacks.comment),
                                  RatingWidget(
                                      rating: userFeedbacks.rating.toDouble()),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              }
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: commentFunction,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.feedback),
                        Text('Give your feedback')
                      ],
                    ),
                  ),
                  const Center(
                    child: Text('No feedback for this product'),
                  ),
                ],
              );
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  final VoidCallback userUpdate;

  Widget _userReview(
    BuildContext context,
    String userComment,
    int userRating,
    int productId,
    UserFeedback feedback,
  ) {
    final TextEditingController showCommentController =
        TextEditingController(text: feedback.comment);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onTap: userUpdate,
              readOnly: true,
              minLines: 5,
              maxLines: 10,
              controller: showCommentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  gapPadding: 4,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
              keyboardType: TextInputType.multiline,

            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RatingWidget(
                    rating: userRating.toDouble(),
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
