import 'dart:developer' as devtools show log;
import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
import 'package:e_commerce_ui_1/temp_user_login/register_firebase_logic.dart';
import 'package:e_commerce_ui_1/temp_user_login/temp_img_handle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<String?> userEmail;
  late Future<String?> userPassword;
  late Future<String?> userId;
  final ImgHandle imgHandle = ImgHandle();
  String? imgUrl;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuthService().currentUserEmail();
    userId = FirebaseAuthService().currentUserId();
    userPassword = FirebaseAuthService().changePassword();
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
        leading: IconButton(onPressed: (){
          Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
        }, icon: const Icon(Icons.arrow_back),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                if (imgUrl != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(),
                      ),
                      child: ClipOval(
                          child: Image.network(
                        imgUrl!,
                        fit: BoxFit.cover,
                      )),
                    ),
                  )
                else
                  const Icon(Icons.account_circle, size: 180),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await imgHandle
                                .removeProfilePicture()
                                .then((_) => Navigator.pushNamedAndRemoveUntil(context, profileRoute, (route) => false));
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Icon(Icons.edit),
                          onPressed: () async {
                            XFile? image = await imgHandle.chooseProfilePhoto();
                            if (image != null) {
                              devtools.log('Image selected:${image.path}');
                              String? url =
                                  await imgHandle.uploadProfileImage(image);
                              if (url != null) {
                                devtools
                                    .log('Image successfully uploaded URL: $url');
                                await imgHandle.saveProfilePhotoUrl(url);
                                setState(() {
                                  imgUrl = url;
                                });
                                devtools.log('setState called. imgUrl updated');
                              } else {
                                devtools.log('Error uploading image');
                              }
                            } else {
                              devtools.log('No image selected');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
