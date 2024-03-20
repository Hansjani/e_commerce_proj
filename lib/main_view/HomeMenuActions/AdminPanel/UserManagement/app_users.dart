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
                      return ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(user.username),
                        subtitle: Text(user.userType),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewUserInfo(user: user),
                            ),
                          );
                        },
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
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
