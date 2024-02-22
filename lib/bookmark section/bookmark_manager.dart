import 'package:flutter/material.dart';

class Bookmark {
  final String title;
  final ImageProvider bookMarkImage;

  Bookmark({required this.title, required this.bookMarkImage});
}

class BookmarkProvider extends ChangeNotifier {
  List<Bookmark> _bookmarks = [];

  List<Bookmark> get bookmarks => _bookmarks;

  int getIndexOfBookmark(Bookmark bookmark) {
    return _bookmarks.indexOf(bookmark);
  }

  void addBookmark(Bookmark bookmark) {
    _bookmarks.add(bookmark);
    notifyListeners();
  }

  void removeBookmark(Bookmark bookmark) {
    _bookmarks.remove(bookmark);
    notifyListeners();
  }

  bool containsBookmark(String bookmarkTitle){
    return _bookmarks.any((bookmark) => bookmark.title == bookmarkTitle);
  }
}
