import 'package:e_commerce_ui_1/main_view/home_page.dart';
import 'package:e_commerce_ui_1/temp_user_login/register_firebase_logic.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../Constants/routes/routes.dart';
import '../Constants/shop_item_images.dart';
import 'bookmark_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final FirebaseAuthService authService = FirebaseAuthService();

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
  Image(image: bookOne),
  Image(image: buyBooks),
  Image(image: buyHomeAplliances),
  Image(image: buyLaptop),
  Image(image: buySmartphone),
];

List<PopupMenuEntry> _buildMenuItems(BuildContext context) {
  return <PopupMenuEntry>[
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Profile'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ),
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.login),
        title: const Text('Sign in'),
        onTap: () {
          Navigator.pop(context);
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
        onTap: () async {
          Navigator.pop(context);
          await authService.logOut().then(
            (value) {
              devtools.log(authService.authentication.currentUser.toString());
            },
          );
        },
      ),
    ),
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, settingsRoute);
        },
      ),
    ),
  ];
}
