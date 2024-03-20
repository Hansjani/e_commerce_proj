// import 'package:e_commerce_ui_1/Constants/item_name.dart';
// import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
// import 'package:e_commerce_ui_1/bookmark%20section/wishlist_toggle.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../bookmark section/wishlist_manager.dart';
// import 'dart:developer' as devtools show log;
//
// class BookmarkView extends StatefulWidget {
//   const BookmarkView({super.key});
//
//   @override
//   State<BookmarkView> createState() => _BookmarkViewState();
// }
//
// class _BookmarkViewState extends State<BookmarkView> {
//   final WishListUtil bookMarkUtil = WishListUtil();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Consumer<WishListProvider>(
//           builder: (context, bookmarkProvider, child) {
//         final bookmarks = bookmarkProvider.wishlist;
//         return ListView.builder(
//           padding: const EdgeInsets.all(8.0),
//           shrinkWrap: true,
//           itemCount: bookmarks.length,
//           itemBuilder: (context, index) {
//             final bookmark = bookmarks[index];
//             return ListTile(
//               title: Text(bookmark.title),
//               leading: SizedBox(
//                 height: 55,
//                 width: 55,
//                 child: Image(
//                   image: bookmark.wishlistImage,
//                 ),
//               ),
//               trailing: IconButton(
//                 onPressed: () {
//                   setState(() {
//                     int indexToRemove =
//                         bookmarkProvider.getIndexOfBookmark(bookmark);
//                     devtools.log('index $indexToRemove');
//                     if (indexToRemove != -1) {
//                       bookmarkProvider.wishlist.removeAt(indexToRemove);
//                     }
//                     devtools.log(bookMarkUtil.isContained.toString());
//                   });
//                 },
//                 icon: const Icon(Icons.delete),
//               ),
//               onTap: () {
//                 if(bookmark.title == theGodfather){
//                   Navigator.pushNamed(context, theGodfatherBookRoute);
//                 } else if (bookmark.title == theBook){
//                   Navigator.pushNamed(context, theBookRoute);
//                 }
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
// }
