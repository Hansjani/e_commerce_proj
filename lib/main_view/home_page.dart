

import 'package:e_commerce/Constants/shop_item_images.dart';
import 'package:e_commerce/main_view/bookmark_view.dart';
import 'package:e_commerce/main_view/home_view.dart';
import 'package:flutter/material.dart';

import '../Constants/routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('E-Commerce'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: const Color.fromARGB(255, 250, 82, 82),
                child: PopupMenuButton(
                  itemBuilder: (context) => _buildMenuItems(context),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.bookmark),
              ),
              Tab(
                icon: Icon(Icons.shopping_cart_rounded),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Column(
              children: [HomePageView()],
            ),
            Column(
              children: [
                BookmarkView(),
              ],
            ),
            Column(
              children: [Icon(Icons.card_travel)],
            )
          ],
        ),
      ),
    );
  }
}

List<Widget> carouselItems = [
  Image(image: poster_1),
  Image(image: poster_2),
  Image(image: poster_3),
  Image(image: poster_4),
  Image(image: poster_5),
  Image(image: poster_6),
  Image(image: poster_7),
];

List<PopupMenuEntry> _buildMenuItems(BuildContext context) {
  return <PopupMenuEntry>[
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Profile'),
        onTap: () {},
      ),
    ),
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.login),
        title: const Text('Sign in'),
        onTap: () {
          Navigator.pushNamed(context, loginRoute);
        },
      ),
    ),
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.logout),
        title: const Text(
          'Sign out',
        ),
        onTap: () {},
      ),
    ),
  ];
}
