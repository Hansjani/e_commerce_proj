import 'package:e_commerce/Constants/routes/routes.dart';
import 'package:e_commerce/Ice-Cream-Bar/Items/bar_item_list.dart';
import 'package:e_commerce/Ice-Cream-Cone/Items/cone_item_list.dart';
import 'package:e_commerce/Ice-Cream-Cup/Items/cup_item_list.dart';
import 'package:e_commerce/Ice-Cream-Tub/Items/tub_item_list.dart';
import 'package:e_commerce/book_views/book_items/strawberry_cup.dart';
import 'package:e_commerce/book_views/book_items/the_godfather_book.dart';
import 'package:e_commerce/book_views/book_items/vanilla_ice_cup.dart';
import 'package:e_commerce/book_views/books_list.dart';
import 'package:e_commerce/bookmark%20section/bookmark_manager.dart';
import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/main_view/home_page.dart';
import 'package:e_commerce/user_interface/user_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_interface/user_login.dart';

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
    return ChangeNotifierProvider<BookmarkProvider>(
      create: (context) => BookmarkProvider(),
      child: MaterialApp(
        title: 'Home',
        home: const HomePage(),
        routes: {
          bookListRoute: (context) => const BookListPage(),
          theGodfatherBookRoute: (context) => const TheGodfatherBook(),
          loginRoute: (context) => const LoginPage(),
          registerRoute: (context) => const RegisterPage(),
          coneRoute: (context) => const IceCreamConesPage(),
          tubRoute: (context) => const IceCreamTubPage(),
          barRoute: (context) => const IceCreamBarPage(),
          cupRoute: (context) => const IceCreamCupPage(),
          vanillaCupRoute: (context) => const VanillaIceCreamCup(),
          strawberryCupRoute: (context) => const StrawberryIceCreamCup(),
        },
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          tabBarTheme: const TabBarTheme(
            dividerColor: Colors.white,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
          ),
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Color.fromARGB(255, 49, 10, 10),
            onPrimary: Color.fromARGB(255, 226, 93, 93),
            secondary: Color.fromARGB(255, 44, 44, 44),
            onSecondary: Color.fromARGB(255, 255, 255, 255),
            error: Color.fromARGB(255, 255, 255, 0),
            onError: Color.fromARGB(255, 253, 148, 45),
            background: Color.fromARGB(255, 255, 114, 145),
            onBackground: Color.fromARGB(255, 91, 0, 0),
            surface: Color.fromARGB(255, 250, 82, 82),
            onSurface: Color.fromARGB(255, 81, 0, 27),
          ),
        ),
      ),
    );
  }
}
