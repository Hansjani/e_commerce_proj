import 'package:flutter/material.dart';

import '../Constants/item_name.dart';
import '../Constants/routes/routes.dart';
import '../Constants/shop_item_images.dart';

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
        title: const Text('Books'),
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
                image: bookOne,
              ),
              title: const Text(theGodfather),
              onTap: () {
                Navigator.pushNamed(context, theGodfatherBookRoute);
              },
            ),
          ),
        ),
      ],
    );
  }
}
