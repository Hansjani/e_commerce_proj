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

class BookListItems extends StatelessWidget {
  const BookListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        ListItemsBooks(
          imageString: bookOne,
          listTitle: theGodfather,
          routeName: theGodfatherBookRoute,
        ),
        ListItemsBooks(
          imageString: showBook,
          listTitle: theBook,
          routeName: theBookRoute,
        ),
        ListItemsBooks(
          imageString: showLaptop,
          listTitle: testBook,
          routeName: testBookRoute,
        ),
      ],
    );
  }
}

class ListItemsBooks extends StatelessWidget {
  final ImageProvider imageString;
  final String listTitle;
  final String routeName;

  const ListItemsBooks(
      {super.key,
      required this.imageString,
      required this.listTitle,
      required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            height: 50,
            width: 50,
            child: Image(
              image: imageString,
            ),
          ),
          title: Text(listTitle),
          onTap: () {
            Navigator.pushNamed(context, routeName);
          },
        ),
        const Divider(
          height: 0,
          thickness: 2,
        ),
      ],
    );
  }
}
