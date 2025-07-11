import 'package:e_commerce/bookmark%20section/bookmark_manager.dart';
import 'package:e_commerce/bookmark%20section/bookmark_toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkView extends StatefulWidget {
  const BookmarkView({super.key});

  @override
  State<BookmarkView> createState() => _BookmarkViewState();
}

class _BookmarkViewState extends State<BookmarkView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          final bookmarks = bookmarkProvider.bookmarks;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            shrinkWrap: true,
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return ListTile(
                title: Text(bookmark.title),
                leading: Image(
                  image: bookmark.bookMarkImage,
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(
                      () {
                        Provider.of<BookmarkProvider>(context, listen: false)
                            .bookmarks
                            .removeAt(
                              bookmarkProvider.getIndexOfBookmark(bookmark),
                            );
                        bookmarkToggleIcon = Icons.bookmark_add;
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
