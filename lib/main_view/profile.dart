import 'package:e_commerce_ui_1/temp_user_login/register_firebase_logic.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<String?> userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuthService().currentUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<String?>(
              future: userEmail,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text('Email'),
                    subtitle: Text('Loading...'),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: const Text('Email'),
                    subtitle: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListTile(
                    title: const Text('Email'),
                    subtitle: Text(snapshot.data ?? 'No email available'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
