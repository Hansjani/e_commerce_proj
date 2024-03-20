import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  final AuthProvider authProvider;

  const UserProfile({super.key, required this.authProvider});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

void getToken() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('userToken');
  print(token);
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    getToken();
    final User? currentUser = widget.authProvider.currentUser;
    if (currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: ${currentUser.username}'),
              Text('Phone Number: ${currentUser.phoneNumber}'),
              if (currentUser.email != null)
                Text('Email: ${currentUser.email!}'),
              if (currentUser.userType != null)
                Text('User Type: ${currentUser.userType!}'),
              if (currentUser.profileImageUrl != null)
                Text('Profile Image URL: ${currentUser.profileImageUrl!}'),
              // Add more fields as needed
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: No user available'),
              Text('Phone Number: No user available'),
              Text('Email: No user available'),
              Text('User Type:  No user available}'),
              Text('Profile Image URL:  No user available'),
              // Add more fields as needed
            ],
          ),
        ),
      );
    }
  }
}
