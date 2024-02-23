import 'package:e_commerce_ui_1/Theme/theme_provider.dart';
import 'package:e_commerce_ui_1/bookmark%20section/bookmark_manager.dart';
import 'package:e_commerce_ui_1/firebase_options.dart';
import 'package:e_commerce_ui_1/main_view/home_view.dart';
import 'package:e_commerce_ui_1/main_view/settings_view.dart';
import 'package:e_commerce_ui_1/temp_user_login/user_login.dart';
import 'package:e_commerce_ui_1/temp_user_login/user_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Constants/routes/routes.dart';
import 'book_views/book_items/the_godfather_book.dart';
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
        ChangeNotifierProvider(create: (context) => ThemeProvider(),),
        ChangeNotifierProvider(create: (context) => BookmarkProvider(),),
      ],
      child: Consumer(
        builder: (BuildContext context, ThemeProvider themeProvider , _){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Home',
            home: const HomePage(),
            routes: {
              bookListRoute: (context) => const BookListPage(),
              theGodfatherBookRoute: (context) => const TheGodfatherBook(),
              loginRoute: (context) => const UserLoginTemp(),
              registerRoute: (context) => const RegisterPageTemp(),
              homeRoute: (context) => const HomePage(),
              settingsRoute: (context) => const SettingsPage(),
            },
            theme:ThemeData(
              brightness: Brightness.light,
              splashColor: Colors.transparent,
            ),
          );
        },
      ),
    );
  }
}
