import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_get_users_api.dart';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
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
          MerchantInfo(user: _user),
        ],
      ),
    );
  }
}

class MerchantInfo extends StatefulWidget {
  const MerchantInfo({
    super.key,
    required Users user,
  }) : _user = user;

  final Users _user;

  @override
  State<MerchantInfo> createState() => _MerchantInfoState();
}

class _MerchantInfoState extends State<MerchantInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserCRUD().getMerchantsForAdminByUsername(widget._user.username),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data != null) {
              final appMerchant = snapshot.data!;
              return _buildContent(widget._user, appMerchant, context);
            } else if (snapshot.hasError) {
              return ItemNameTwo(itemName: snapshot.error.toString());
            } else {
              return _buildContent(widget._user, null, context);
            }
          default:
            return const LinearProgressIndicator();
        }
      },
    );
  }

  Widget _buildContent(
      Users user, AppMerchant? appMerchant, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            height: 250,
            width: 250,
            child: Image.network(widget._user.imageUrl),
          ),
        ),
        ItemNameTwo(itemName: 'User ID : ${widget._user.id}'),
        ItemNameTwo(itemName: 'Username : ${widget._user.username}'),
        ItemNameTwo(itemName: 'Email : ${widget._user.email}'),
        ItemNameTwo(itemName: 'PhoneNumber : ${widget._user.phoneNumber}'),
        ItemNameTwo(itemName: 'User Type : ${widget._user.userType}'),
        if (appMerchant != null) ...[
          ItemNameTwo(itemName: 'Company : ${appMerchant.company}'),
          Row(
            children: [
              ItemNameTwo(
                itemName:
                    'Approval : ${appMerchant.isApproved == 1 ? 'Approved' : 'Not approved'}',
              ),
              Switch(
                value: appMerchant.isApproved == 1 ? true : false,
                onChanged: (value) async {
                  UserCRUD().updateMerchantApproval(appMerchant.username, value,
                      (message) {
                    onSuccess(context, message, () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    });
                  }, (error) {
                    onError(context, error);
                  });
                },
              ),
            ],
          ),
        ],
      ],
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
