import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/AdminPanel/ProductManagement/view_product_for_admin.dart';
import 'package:flutter/material.dart';

class AllProductsForAdmin extends StatefulWidget {
  const AllProductsForAdmin({super.key});

  @override
  State<AllProductsForAdmin> createState() => _AllProductsForAdminState();
}

class _AllProductsForAdminState extends State<AllProductsForAdmin> {
  Key imageKey = UniqueKey();
  late Future<List<Item>?> _appProducts;

  @override
  void initState() {
    _appProducts = ItemCRUD().getProductsForAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: FutureBuilder(
        future: _appProducts,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                final products = snapshot.data;
                if (products!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        child: ListTile(
                          leading: SizedBox(
                            width: 60,
                            height: 100,
                            child: Image.network(
                              key: imageKey,
                              product.productImage,
                              errorBuilder: (context, error, stackTrace) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imageKey = UniqueKey();
                                        });
                                      },
                                      child: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const Text('Failed to load data'),
                                  ],
                                );
                              },
                            ),
                          ),
                          title: Text(product.productName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ProductID : ${product.productId}'),
                              Text('Provider : ${product.provider}'),
                              Text(
                                  'Status : ${int.parse(product.productStatus) == 1 ? 'approved' : 'not approved'}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewProductInfo(item: product),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No product found'),
                  );
                }
              } else {
                return const Center(
                  child: Text('No data found'),
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
