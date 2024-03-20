import 'package:e_commerce_ui_1/Theme/theme_provider.dart';
import 'package:e_commerce_ui_1/cart/cart_provider.dart';
import 'package:e_commerce_ui_1/cart/cart_toggle.dart';
import 'package:e_commerce_ui_1/firebase_options.dart';
import 'package:e_commerce_ui_1/main_view/Home/home_main.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/login.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/profile.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/register.dart';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:e_commerce_ui_1/main_view/billing_section.dart';
import 'package:e_commerce_ui_1/main_view/profile.dart';
import 'package:e_commerce_ui_1/main_view/settings_view.dart';
import 'package:e_commerce_ui_1/temp_user_login/user_login.dart';
import 'package:e_commerce_ui_1/temp_user_login/user_register.dart';
import 'package:e_commerce_ui_1/temp_user_login/user_update.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Constants/routes/routes.dart';
import 'book_views/books_list.dart';
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

  const MainApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // ChangeNotifierProvider(create: (context) => WishListProvider()),
        // ChangeNotifierProvider(create: (context) => WishListUtil()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => CartUtil()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => CartItemProvider(),),
        ChangeNotifierProvider.value(value: authProvider)
      ],
      child: Consumer(
        builder: (BuildContext context,AuthProvider authProvider, child){
          return MaterialApp(
            debugShowCheckedModeBanner: true,
            title: 'Home',
            home: MainPage(authProvider: authProvider),
            navigatorKey: navigatorKey,
            routes: {
              bookListRoute: (context) => const BookListPage(),
              loginRoute: (context) => const UserLoginTemp(),
              registerRoute: (context) => const RegisterPageTemp(),
              // homeRoute: (context) => const HomePage(),
              settingsRoute: (context) => const SettingsPage(),
              // theBookRoute: (context) => const TheChosenBook(),
              // theGodfatherBookRoute: (context) => const TheGodfather(),
              billRoute: (context) => const BillView(),
              profileRoute: (context) => const ProfileView(),
              // testBookRoute: (context) => const TestBook(),
              updateRoute: (context) => const UserUpdate(),
              mainPageRoute: (context) => MainPage(authProvider: authProvider,),
              userProfileRoute: (context) => UserProfile(authProvider: authProvider),
              userLoginRoute: (context) => UserLoginMain(authProvider: authProvider),
              userRegisterRout: (context) => UserRegisterMain(authProvider: authProvider),
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
