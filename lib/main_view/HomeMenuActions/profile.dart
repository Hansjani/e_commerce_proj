import 'dart:developer';

import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:e_commerce_ui_1/main_view/photo_items_logic/image_handle.dart';
import 'package:e_commerce_ui_1/main_view/photo_items_logic/profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  final AuthProvider authProvider;

  const UserProfile({super.key, required this.authProvider});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late User? user;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController initUsernameController = TextEditingController();
  final TextEditingController initPhoneController = TextEditingController();
  final TextEditingController initEmailController = TextEditingController();

  late ImgHandle imgHandle = ImgHandle();

  @override
  void initState() {
    user = widget.authProvider.currentUser;
    initUsernameController.text = user!.username;
    initPhoneController.text = user!.phoneNumber;
    initEmailController.text = user!.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(user!.profileImageUrl!);
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (user!.profileImageUrl != 'null')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageDialog(
                    imageUrl: user?.profileImageUrl,
                    onUpdateProfilePicture: () {
                      imgHandle.getCurrentUrl().then((url) {
                        imgHandle.saveProfilePhotoUrl(url!).then((value) {
                          log(url);
                          widget.authProvider.updateUser(profileImageUrl: url);
                          setState(() {
                            user!.profileImageUrl = url;
                          });
                        });
                      });
                    },
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageDialogNull(
                    imageUrl: user?.profileImageUrl,
                    onUpdateProfilePicture: () {
                      imgHandle.getCurrentUrl().then((url) {
                        imgHandle.saveProfilePhotoUrl(url!).then((value) {
                          widget.authProvider.updateUser(profileImageUrl: url);
                          setState(() {
                            user!.profileImageUrl = url;
                          });
                        });
                      });
                    },
                  ),
                ),
              ProfileField(
                currentUser: user,
                initValueController: initUsernameController,
                inputValueController: usernameController,
                fieldTitle: 'Username',
                fieldTitleValue: user!.username,
                detail: 'username',
                hint: 'username',
                updateFunction: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs
                      .setString(PrefsKeys.userName, usernameController.text)
                      .then((value) {
                    widget.authProvider
                        .updateUser(username: usernameController.text);
                    setState(() {
                      user?.username = usernameController.text;
                    });
                    Navigator.pop(context);
                  });
                },
              ),
              if (user?.email != null)
                ProfileField(
                  currentUser: user,
                  initValueController: initEmailController,
                  inputValueController: emailController,
                  fieldTitle: 'Email',
                  fieldTitleValue: user!.email!,
                  detail: 'email',
                  hint: 'email',
                  updateFunction: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs
                        .setString(PrefsKeys.userEmail, emailController.text)
                        .then((value) {
                      widget.authProvider
                          .updateUser(email: emailController.text);
                      setState(() {
                        user?.email = emailController.text;
                      });
                      Navigator.pop(context);
                    });
                  },
                ),
              ProfileField(
                currentUser: user,
                initValueController: initPhoneController,
                inputValueController: phoneController,
                fieldTitle: 'Phone Number',
                fieldTitleValue: user!.phoneNumber,
                detail: 'phone number',
                hint: 'phone number',
                updateFunction: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs
                      .setString(PrefsKeys.userPhone, phoneController.text)
                      .then((value) {
                    widget.authProvider
                        .updateUser(phoneNumber: phoneController.text);
                    setState(() {
                      user?.phoneNumber = phoneController.text;
                    });
                    Navigator.pop(context);
                  });
                },
              ),
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

class ProfileField extends StatelessWidget {
  const ProfileField({
    super.key,
    required this.currentUser,
    required this.initValueController,
    required this.inputValueController,
    required this.fieldTitle,
    required this.fieldTitleValue,
    required this.detail,
    required this.hint,
    this.keyboardType = TextInputType.text,
    required this.updateFunction,
  });

  final User? currentUser;
  final TextEditingController initValueController;
  final TextEditingController inputValueController;
  final String fieldTitle;
  final String fieldTitleValue;
  final String detail;
  final String hint;
  final TextInputType keyboardType;
  final VoidCallback updateFunction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('$fieldTitle : $fieldTitleValue'),
        trailing: IconButton(
          onPressed: () {
            updateProfile(
              context,
              detail,
              hint,
              keyboardType,
              initValueController,
              inputValueController,
              updateFunction,
            );
          },
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}

updateProfile(
    BuildContext context,
    String detail,
    String hint,
    TextInputType keyboardType,
    TextEditingController initValueController,
    TextEditingController inputValueController,
    void Function() updateFunction) {
  showDialog(
    context: context,
    builder: (context) {
      return UpdateProfileDetailsAlert(
        detail: detail,
        hint: hint,
        keyboardType: keyboardType,
        initValue: initValueController,
        inputValue: inputValueController,
        updateFunction: updateFunction,
      );
    },
  );
}

class UpdateProfileDetailsAlert extends StatelessWidget {
  final String detail;
  final String hint;
  final TextInputType keyboardType;
  final TextEditingController initValue;
  final TextEditingController inputValue;
  final VoidCallback updateFunction;

  const UpdateProfileDetailsAlert({
    super.key,
    required this.detail,
    required this.hint,
    required this.keyboardType,
    required this.initValue,
    required this.inputValue,
    required this.updateFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update $detail'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                alignLabelWithHint: true,
                hintText: hint,
                label: Text(hint),
              ),
              keyboardType: keyboardType,
              readOnly: true,
              controller: initValue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                alignLabelWithHint: true,
                hintText: 'New $hint',
                label: Text('New $hint'),
              ),
              keyboardType: keyboardType,
              readOnly: false,
              controller: inputValue,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        TextButton(onPressed: updateFunction, child: const Text('Update')),
      ],
    );
  }
}
