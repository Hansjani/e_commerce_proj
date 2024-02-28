import 'package:e_commerce_ui_1/cart/cart_provider.dart';
import 'package:e_commerce_ui_1/main_view/bookmark_view.dart';
import 'package:e_commerce_ui_1/main_view/cart_view.dart';
import 'package:e_commerce_ui_1/main_view/home_page.dart';
import 'package:e_commerce_ui_1/temp_user_login/register_firebase_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as devtools show log;
import '../Constants/routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _homeOptions = <Widget>[
    HomePageView(),
    BookmarkView(),
    CartView(),
  ];

  void _changeView(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('HomeView Build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Commerce'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
              itemBuilder: (context) => _buildMenuItems(context),
            ),
          ),
        ],
      ),
      body: _homeOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        selectedIconTheme: const IconThemeData(
          size: 35,
        ),
        onTap: _changeView,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: false,
              child: Icon(Icons.favorite),
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: BadgeIconForCart(),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

final FirebaseAuthService authService = FirebaseAuthService();

List<PopupMenuEntry> _buildMenuItems(BuildContext context) {
  return <PopupMenuEntry>[
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Profile'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, profileRoute);
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

class BadgeIconForCart extends StatefulWidget {
  const BadgeIconForCart({super.key});

  @override
  State<BadgeIconForCart> createState() => _BadgeIconForCartState();
}

class _BadgeIconForCartState extends State<BadgeIconForCart> {
  @override
  Widget build(BuildContext context) {
    print('Badge build');
    return Consumer(builder: (context,CartProvider cartProvider, child) {
      int cartItems = cartProvider.cartList.length;
      return Badge(
        isLabelVisible: cartItems <= 0 ? false : true,
        label: Text(cartItems.toString()),
        child: const Icon(Icons.shopping_cart),
      );
    },);
  }
}

