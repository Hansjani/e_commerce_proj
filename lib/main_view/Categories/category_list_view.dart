import 'package:e_commerce_ui_1/APIs/ProductAPI/product_feedback.dart';
import 'package:e_commerce_ui_1/main_view/Categories/category_item_view.dart';
import 'package:flutter/material.dart';

import '../../APIs/AdminActionAPI/item_management_api.dart';

class CategoryListView extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String userType;

  const CategoryListView({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.userType,
  });

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = widget.userType == 'admin' || widget.userType == 'merchant'
        ? ItemCRUD().readItem(widget.categoryId)
        : ItemCRUD().readItemForCustomer(widget.categoryId);
  }

  Future<void> _refreshItemList() async {
    setState(() {
      widget.userType == 'admin' || widget.userType == 'merchant'
          ? ItemCRUD().readItem(widget.categoryId)
          : ItemCRUD().readItemForCustomer(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshItemList,
        child: FutureBuilder(
          future: _futureItems,
          builder: (context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasData) {
              List<Item> items = snapshot.data!;
              if (items.isNotEmpty) {
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Item item = items[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CategoryItemView(
                                  productID: int.parse(item.productId),
                                );
                              },
                            ),
                          );
                        },
                        leading: SizedBox(
                          width: 60,
                          child: Image.network(item.productImage),
                        ),
                        title: Text(item.productName),
                        subtitle: FutureBuilder(
                          future: ProductFeedbackAPI().getRatings(
                            int.parse(item.productId),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else if (snapshot.hasData) {
                              double ratings = snapshot.data!;
                              return RatingWidget(rating: ratings);
                            } else {
                              return const Text('loading ratings...');
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No items available'),
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text('Error : ${snapshot.error}'));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
