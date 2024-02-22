import 'package:e_commerce/Constants/routes/routes.dart';
import 'package:e_commerce/Constants/shop_item_images.dart';
import 'package:flutter/material.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flavours'),
      ),
      body: const BookListItems(),
    );
  }
}

class BookListItems extends StatefulWidget {
  const BookListItems({super.key});

  @override
  State<BookListItems> createState() => _BookListItemsState();
}

class _BookListItemsState extends State<BookListItems> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: vanilla,
              ),
              title: const Text('Vanilla'),
              onTap: (){
                Navigator.pushNamed(context, vanillaCupRoute);
              },
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: chocolate,
              ),
              title: const Text('Chocolate'),
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: cookies,
              ),
              title: const Text('Cookies and Cream'),
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: chocoChips,
              ),
              title: const Text('Chocolate Chips'),
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: strawBerry,
              ),
              title: const Text('Strawberry'),
              onTap: (){
                Navigator.pushNamed(context, strawberryCupRoute);
              },
            ),
          ),
        ),
      ],
    );
  }
}
