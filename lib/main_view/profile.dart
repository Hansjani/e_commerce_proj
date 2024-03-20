import 'dart:developer' as devtools show log;
import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
import 'package:e_commerce_ui_1/main_view/photo_items_logic/profile_add.dart';
import 'package:e_commerce_ui_1/temp_user_login/firebase_logic.dart';
import 'package:e_commerce_ui_1/temp_user_login/temp_img_handle.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<String?> userEmail;
  final ImgHandle imgHandle = ImgHandle();
  String? imgUrl;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuthService().currentUserEmail();
    imgHandle.getCurrentUrl().then((url) {
      setState(() {
        imgUrl = url;
      });
    }).catchError((error) {
      devtools.log('Error getting current URL: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (imgUrl == null) {
      devtools.log('null');
    } else {
      devtools.log(imgUrl!);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, homeRoute, (route) => false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                if (imgUrl != null)
                  ImageDialog(
                    imageUrl: imgUrl,
                    onUpdateProfilePicture: () {
                      imgHandle.getCurrentUrl().then((url) => setState(() {
                            imgUrl = url;
                          }));
                    },
                  )
                else
                  ImageDialogNull(
                    imageUrl: imgUrl,
                    onUpdateProfilePicture: () {
                      imgHandle.getCurrentUrl().then((url) => setState(() {
                            imgUrl = url;
                          }));
                    },
                  ),
              ],
            ),
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
                    subtitle: Text(snapshot.data ?? 'No user logged in'),
                  );
                }
              },
            ),
            FutureBuilder<String?>(
              future: FirebaseAuthService().gottenUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text('Username'),
                    subtitle: Text('Loading...'),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: const Text('Username'),
                    subtitle: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListTile(
                    title: const Text('Username'),
                    subtitle: Text(snapshot.data ?? 'No user logged in'),
                  );
                }
              },
            ),
            FutureBuilder<String?>(
              future: FirebaseAuthService().gottenPhoneNumber(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: Text('Phone number'),
                    subtitle: Text('Loading...'),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: const Text('Phone number'),
                    subtitle: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListTile(
                    title: const Text('Phone number'),
                    subtitle: Text(snapshot.data ?? 'No user logged in'),
                  );
                }
              },
            ),
            ElevatedButton(
                onPressed: () {
                  devtools.log('message');
                  Navigator.pushNamed(context, updateRoute);
                },
                child: const Text('Update details')),
          ],
        ),
      ),
    );
  }
}
