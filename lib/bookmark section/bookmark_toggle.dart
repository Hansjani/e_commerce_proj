import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bookmark_manager.dart';

class BookMarkUtil{
  bool _isContains = false;

  void bookmarkToggle({
    required BuildContext context,
    required String bookmarkString,
    required ImageProvider bookmarkImage,
  }) {

    BookmarkProvider bookmarkProvider = Provider.of<BookmarkProvider>(context,listen: false);
    _isContains = bookmarkProvider.containsBookmark(bookmarkString);

    if (_isContains) {
      Provider.of<BookmarkProvider>(context, listen: false)
          .bookmarks
          .removeWhere((bookmark) => bookmark.title == bookmarkString);
      print('cant');
      _isContains = false;
    } else {
      final Bookmark bookmark = Bookmark(
        title: bookmarkString,
        bookMarkImage: bookmarkImage,
      );
      Provider.of<BookmarkProvider>(context, listen: false).addBookmark(bookmark);
      print('object');
      _isContains = true;
    }
  }
  bool get isContained => _isContains;

  void available(){
    bool isAvailable = _isContains;
    if(isAvailable){
      print('Inside');
    } else {
      print('Outside');
    }
  }
}
