import 'package:e_commerce_ui_1/main_view/Categories/category_item_view.dart';
import 'package:e_commerce_ui_1/main_view/Providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainWishlistPage extends StatefulWidget {
  const MainWishlistPage({super.key});

  @override
  State<MainWishlistPage> createState() => _MainWishlistPageState();
}

class _MainWishlistPageState extends State<MainWishlistPage> {
  @override
  void initState() {
    Provider.of<WishlistProvider>(context, listen: false).initWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        if (wishlistProvider.wishlist.isEmpty) {
          return const Center(
            child: Text('Wishlist is empty'),
          );
        } else {
          return ListView.builder(
            itemCount: wishlistProvider.wishlist.length,
            itemBuilder: (context, index) {
              final item = wishlistProvider.wishlist[index];
              return SizedBox(
                height: 70,
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  margin:
                      const EdgeInsets.symmetric(vertical: 0.9, horizontal: 10),
                  elevation: 2,
                  child: Center(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryItemView(productID: item.productId,),
                          ),
                        );
                      },
                      leading: SizedBox(
                        width: 50,
                        height: 60,
                        child: Image.network(item.imageUrl),
                      ),
                      title: Text(item.title),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
