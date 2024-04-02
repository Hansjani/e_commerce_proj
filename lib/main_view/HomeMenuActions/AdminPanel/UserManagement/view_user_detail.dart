import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_get_users_api.dart';
import 'package:flutter/material.dart';

class ViewUserInfo extends StatefulWidget {
  final Users user;

  const ViewUserInfo({super.key, required this.user});

  @override
  State<ViewUserInfo> createState() => _ViewUserInfoState();
}

class _ViewUserInfoState extends State<ViewUserInfo> {
  late Users _user;

  @override
  void initState() {
    _user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_user.username),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 250,
              width: 250,
              child: Image.network(_user.imageUrl),
            ),
          ),
          ItemNameTwo(itemName: 'User ID : ${_user.id}'),
          ItemNameTwo(itemName: 'Username : ${_user.username}'),
          ItemNameTwo(itemName: 'Email : ${_user.email}'),
          ItemNameTwo(itemName: 'PhoneNumber : ${_user.phoneNumber}'),
          ItemNameTwo(itemName: 'User Type : ${_user.userType}'),
          ItemNameTwo(itemName: 'Company : ${_user.userCompany}'),
        ],
      ),
    );
  }
}

class ItemNameTwo extends StatelessWidget {
  const ItemNameTwo({super.key, required this.itemName});

  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            itemName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}