import 'package:e_commerce_ui_1/APIs/UserAPI/user_action_api.dart';
import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/AdminPanel/admin_panel.dart';
import 'package:e_commerce_ui_1/main_view/Home/cart_page.dart';
import 'package:e_commerce_ui_1/main_view/Home/home_page.dart';
import 'package:e_commerce_ui_1/main_view/Home/wishlist_page.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/login.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/register.dart';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as devtools show log;
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  final AuthProvider authProvider;

  const MainPage({super.key, required this.authProvider});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late String userType;

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString("userType");
    prefs.getString("userToken");
    return userType;
  }

  @override
  void initState() {
    getUserType().then((value) => setState(() {
          userType = value ?? '';
        }));
    widget.authProvider.initUser();
    super.initState();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    devtools.log('HomeView Build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Commerce'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: getUserType(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return PopupMenuButton(
                    itemBuilder: (context) {
                      String? userType = snapshot.data;
                      return _menuItems(context, userType);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          MainHomePage(),
          MainWishlistPage(),
          MainCartPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        selectedIconTheme: const IconThemeData(
          size: 35,
        ),
        onTap: _onItemTapped,
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
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

List<PopupMenuEntry> _menuItems(BuildContext context, String? user) {
  AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
  WishlistProvider wishlistProvider =
      Provider.of<WishlistProvider>(context, listen: false);

  List<PopupMenuEntry> commonMenuItems = [
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Profile'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, userProfileRoute);
        },
      ),
    ),
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ),
    PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () {
          Navigator.pop(context);
          wishlistProvider.syncWithDatabase().then((value) {
            wishlistProvider.wishlist.clear();
            authProvider.logout().then((value) {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return MainPage(authProvider: authProvider);
              }), (route) => false);
            });
          });
        },
      ),
    ),
  ];

  if (user == null) {
    return <PopupMenuEntry>[
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.login),
          title: const Text('Login'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return UserLoginMain(
                  authProvider: authProvider,
                );
              },
            ), (route) => false);
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.app_registration),
          title: const Text('Register'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return UserRegisterMain(
                  authProvider: authProvider,
                );
              },
            ), (route) => false);
          },
        ),
      ),
    ];
  } else if (user == 'admin') {
    return commonMenuItems +
        <PopupMenuEntry>[
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin panel'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminPanelList(),
                    ));
              },
            ),
          ),
        ];
  } else if (user == 'merchant') {
    return commonMenuItems +
        <PopupMenuEntry>[
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Merchant options'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ];
  } else {
    return commonMenuItems;
  }
}
