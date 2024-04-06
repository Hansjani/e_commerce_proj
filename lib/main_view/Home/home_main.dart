import 'dart:async';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_get_users_api.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_notification_api.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/APIs/UserAPI/user_action_api.dart';
import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/AdminPanel/admin_panel.dart';
import 'package:e_commerce_ui_1/main_view/Home/cart_page.dart';
import 'package:e_commerce_ui_1/main_view/Home/home_page.dart';
import 'package:e_commerce_ui_1/main_view/Home/wishlist_page.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/merchant_options.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/OrderTab/order_history.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/login.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/register.dart';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as devtools show log;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/SharedPreferences/key_names.dart';

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
  bool _isLoggingOut = false;
  late bool isApproved;

  Future<bool> approval() async {
    return UserCRUD().isApprovedMerchant();
  }

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString("userType");
    prefs.getString(PrefsKeys.userToken);
    return userType;
  }

  Future<void> initUserTypeAndApprovalWithNotifications() async {
    userType = 'guest';
    final result = await Future.wait([
      getUserType(),
      approval(),
    ]);
    setState(() {
      userType = result[0] as String? ?? 'guest';
      isApproved = result[1] as bool? ?? false;
    });
  }

  @override
  void initState() {
    initUserTypeAndApprovalWithNotifications();
    widget.authProvider.initUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminNotificationProvider>().loadOnFirstLogin();
    });
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

  Future<void> _logOut() async {
    setState(() {
      _isLoggingOut = true;
    });
    await widget.authProvider.logout();
    setState(() {
      _isLoggingOut = false;
    });
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
                  return const Icon(Icons.block_rounded);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return PopupMenuButton(
                    itemBuilder: (BuildContext menuContext) {
                      String? userType = snapshot.data;
                      return _menuItems(context, menuContext, userType);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              MainHomePage(userType: widget.authProvider.currentUser?.userType ?? 'Guest',),
              const MainWishlistPage(),
              const MainCartPage(),
            ],
          ),
          if (_isLoggingOut)
            ModalBarrier(
              color: Colors.black.withOpacity(0.3),
              dismissible: false,
            ),
          if (_isLoggingOut)
            const Center(
              child: CircularProgressIndicator(),
            ),
          FutureBuilder(
            future: getUserType(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                return const SizedBox();
              } else {
                String futureUserType = snapshot.data;
                if (futureUserType == 'admin') {
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    left: userType == 'admin'
                        ? 0
                        : -MediaQuery.of(context).size.width,
                    top: 0,
                    child: NotificationOverlay(
                      functionNotification: () {},
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }
            },
          ),
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

  List<PopupMenuEntry> _menuItems(
      BuildContext context, BuildContext menuContext, String? user) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    WishlistProvider wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    CartItemProvider cartItemProvider = Provider.of(context, listen: false);

    List<PopupMenuEntry> commonMenuItems = [
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          onTap: () {
            Navigator.pop(menuContext);
            Navigator.pushNamed(context, userProfileRoute);
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.pop(menuContext);
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.history_rounded),
          title: const Text('History'),
          onTap: () {
            Navigator.pop(menuContext);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistory(),
                ));
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            wishlistProvider.syncWithDatabase().then((value) {
              wishlistProvider.wishlist.clear();
              cartItemProvider.cartItems.clear();
              Navigator.pop(menuContext);
              areYouSure(context, () {
                _logOut().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, mainPageRoute, (route) => false);
                });
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
              Navigator.pop(menuContext);
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
              Navigator.pop(menuContext);
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
                  Navigator.pop(menuContext);
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
                  Navigator.pop(menuContext);
                  if (isApproved == false) {
                    onInApproved(
                        context, 'Pending merchant approval! Login again later.');
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantOptions(),
                      ),
                    );
                  }
                },
              ),
            ),
          ];
    } else {
      return commonMenuItems;
    }
  }
}

class NotificationOverlay extends StatelessWidget {
  final VoidCallback functionNotification;

  const NotificationOverlay({super.key, required this.functionNotification});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminNotificationProvider>(
      builder:
          (BuildContext context, adminNotificationProvider, Widget? child) {
        List<AdminNotifications> notifications =
            adminNotificationProvider.newNotifications;
        if (notifications.isEmpty) {
          return const SizedBox();
        }
        return Container(
          color: Colors.black.withOpacity(0.5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              AdminNotifications notification = notifications[index];
              return Dismissible(
                key: ValueKey(notification.id),
                onDismissed: (direction) {
                  functionNotification();
                  AdminNotificationAPI().updateNotificationStatus(
                    notification.id,
                    (message) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                    },
                  ).then((value) =>
                      adminNotificationProvider.onRead(notification));
                },
                child: Card(
                  child: ListTile(
                    title: Text('Notification type : ${notification.type}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Text : ${notification.text}'),
                        Text('Admin action : ${notification.status}'),
                        Text('Admin status : ${notification.notificationStatus}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
