import 'package:flutter/material.dart';
import 'UserManagement/app_users.dart';

class AdminPanelList extends StatefulWidget {
  const AdminPanelList({super.key});

  @override
  State<AdminPanelList> createState() => _AdminPanelListState();
}

class _AdminPanelListState extends State<AdminPanelList> {
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
                    builder: (context) => const ApplicationUsers(),
                  ));
            },
          ),
          ListTile(
            title: const Text('App Products'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('User Orders'),
            onTap: () {},
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
