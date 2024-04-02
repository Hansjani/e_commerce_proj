import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_get_users_api.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/Products/add_products.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/Products/update_product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../APIs/AdminActionAPI/item_management_api.dart';
import '../../../../Constants/SharedPreferences/key_names.dart';

class MerchantProducts extends StatefulWidget {
  const MerchantProducts({super.key});

  @override
  State<MerchantProducts> createState() => _MerchantProductsState();
}

class _MerchantProductsState extends State<MerchantProducts> {
  String? username;
  late Future<List<Item>> futureItems;
  late Users? user;

  Future<List<Item>> _getItems() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString(PrefsKeys.userName);
    if (username != null) {
      user = await UserCRUD().getByUsername(username!);
      List<Item> items =
          await ItemCRUD().readByProductProvider(user!.userCompany);
      if (items.isEmpty) {
        return [];
      } else {
        return items;
      }
    } else {
      return [];
    }
  }

  @override
  void initState() {
    futureItems = _getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProduct(),
                  ),
                );
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Item> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: SizedBox(
                    height: 55,
                    width: 55,
                    child: Image.network(item.productImage),
                  ),
                  title: Text(item.productName),
                  subtitle: Text('Stock : ${item.productStock}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProducts(
                          itemId: int.parse(item.productId),
                        ),
                      ),
                    );
                  },
                );
              },
            );
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
    );
  }
}
