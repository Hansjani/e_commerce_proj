import 'package:e_commerce_ui_1/Theme/theme_provider.dart';
import 'package:e_commerce_ui_1/book_views/book_items/testItem.dart';
import 'package:e_commerce_ui_1/book_views/book_items/theGodfather.dart';
import 'package:e_commerce_ui_1/book_views/book_items/theChosenOne.dart';
import 'package:e_commerce_ui_1/bookmark%20section/wishlist_manager.dart';
import 'package:e_commerce_ui_1/bookmark%20section/wishlist_toggle.dart';
import 'package:e_commerce_ui_1/cart/cart_provider.dart';
import 'package:e_commerce_ui_1/cart/cart_toggle.dart';
import 'package:e_commerce_ui_1/firebase_options.dart';
import 'package:e_commerce_ui_1/main_view/billing_section.dart';
import 'package:e_commerce_ui_1/main_view/home_view.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => WishListProvider()),
        ChangeNotifierProvider(create: (context) => WishListUtil()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => CartUtil()),
      ],
      child: Consumer(
        builder: (BuildContext context, ThemeProvider themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: true,
            title: 'Home',
            home: const HomePage(),
            routes: {
              bookListRoute: (context) => const BookListPage(),
              loginRoute: (context) => const UserLoginTemp(),
              registerRoute: (context) => const RegisterPageTemp(),
              homeRoute: (context) => const HomePage(),
              settingsRoute: (context) => const SettingsPage(),
              theBookRoute: (context) => const TheChosenBook(),
              theGodfatherBookRoute: (context) => const TheGodfather(),
              billRoute: (context) => const BillView(),
              profileRoute: (context) => const ProfileView(),
              testBookRoute: (context) => const TestBook(),
              updateRoute:(context) => const UserUpdate(),
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
