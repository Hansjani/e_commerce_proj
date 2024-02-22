import 'package:e_commerce/bookmark%20section/bookmark_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

IconData bookmarkToggleIcon = Icons.bookmark_add;


void bookmarkToggle({
  required BuildContext context,
  required String bookmarkString,
  required ImageProvider bookmarkImage,
}) {

  BookmarkProvider bookmarkProvider = Provider.of<BookmarkProvider>(context,listen: false);

  if (bookmarkProvider.containsBookmark(bookmarkString)) {
    Provider.of<BookmarkProvider>(context, listen: false)
        .bookmarks
        .removeWhere((bookmark) => bookmark.title == bookmarkString);
    bookmarkToggleIcon = Icons.bookmark_add;
    print('cant');
  } else {
    final Bookmark bookmark = Bookmark(
      title: bookmarkString,
      bookMarkImage: bookmarkImage,
    );
    Provider.of<BookmarkProvider>(context, listen: false).addBookmark(bookmark);
    bookmarkToggleIcon = Icons.bookmark;

    print('object');
  }
}

