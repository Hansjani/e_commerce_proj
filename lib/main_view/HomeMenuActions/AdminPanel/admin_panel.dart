import 'package:e_commerce_ui_1/main_view/HomeMenuActions/AdminPanel/Notifications/admin_notification.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/AdminPanel/OrderManagement/all_orders_list.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/AdminPanel/ProductManagement/get_products_for_admin.dart';
import 'package:flutter/material.dart';
import 'UserManagement/app_users.dart';

class AdminPanelList extends StatefulWidget {
  const AdminPanelList({super.key});

  @override
  State<AdminPanelList> createState() => _AdminPanelListState();
}

class _AdminPanelListState extends State<AdminPanelList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('App Users'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApplicationUsers()));
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminNotification(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('App Products'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllProductsForAdmin(),
                  ));
            },
          ),
          ListTile(
            title: const Text('User Orders'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllOrderList(),
                  ));
            },
          ),
          ListTile(
            title: const Text('User Wishlists'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
