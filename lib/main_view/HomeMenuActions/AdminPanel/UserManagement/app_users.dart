import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_get_users_api.dart';
import 'package:flutter/material.dart';

import 'view_user_detail.dart';

class ApplicationUsers extends StatefulWidget {
  const ApplicationUsers({super.key});

  @override
  State<ApplicationUsers> createState() => _ApplicationUsersState();
}

class _ApplicationUsersState extends State<ApplicationUsers> {
  late Future<List<Users>?> _appUsers;

  @override
  void initState() {
    _appUsers = UserCRUD().readUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: FutureBuilder(
        future: _appUsers,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                final users = snapshot.data;
                if (users!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        child: ListTile(
                          leading: Text('${index + 1}'),
                          title: Text(user.username),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('User Type : ${user.userType}'),
                              Text('User Company : ${user.userCompany}'),
                              if (user.userCompany != 'N/A' &&
                                  user.userCompany != 'No company')
                                FutureBuilder(
                                  future: UserCRUD()
                                      .getMerchantsForAdminByUsername(
                                          user.username),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text('${snapshot.error}'),
                                      );
                                    } else if (snapshot.hasData) {
                                      AppMerchant? merchant = snapshot.data;
                                      if (merchant != null) {
                                        return Column(
                                          children: [
                                            Text(
                                                'MerchantID : ${merchant.id.toString()}'),
                                            Text(
                                              'Merchant ${merchant.isApproved == 1 ? 'approved' : 'not approved'}',
                                            ),
                                          ],
                                        );
                                      } else {
                                        return const Text('Invalid merchant');
                                      }
                                    } else {
                                      return const LinearProgressIndicator();
                                    }
                                  },
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewUserInfo(
                                  user: user,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No user found'),
                  );
                }
              } else {
                return const Center(
                  child: Text('No data found'),
                );
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
