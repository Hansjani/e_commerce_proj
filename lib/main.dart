import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_notification_api.dart';
import 'package:e_commerce_ui_1/firebase_options.dart';
import 'package:e_commerce_ui_1/main_view/Home/home_main.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/login.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/profile.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/register.dart';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Constants/routes/routes.dart';
import 'main_view/Providers/wishlist_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authProvider = AuthProvider();
  await authProvider.initUser();
  runApp(MainApp(
    authProvider: authProvider,
  ));
}

class MainApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MainApp({
    super.key,
    required this.authProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AdminNotificationProvider(),
        ),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => CartItemProvider()),
        ChangeNotifierProvider.value(value: authProvider)
      ],
      child: Consumer(
        builder: (BuildContext context, AuthProvider authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: true,
            title: 'Home',
            home: MainPage(
              authProvider: authProvider,
            ),
            navigatorKey: navigatorKey,
            routes: {
              mainPageRoute: (context) => MainPage(
                    authProvider: authProvider,
                  ),
              userProfileRoute: (context) =>
                  UserProfile(authProvider: authProvider),
              userLoginRoute: (context) =>
                  UserLoginMain(authProvider: authProvider),
              userRegisterRout: (context) =>
                  UserRegisterMain(authProvider: authProvider),
            },
            theme: ThemeData(
              brightness: Brightness.light,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                elevation: 8,
              ),
            ),
          );
        },
      ),
    );
  }
}
