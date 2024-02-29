import 'package:e_commerce_ui_1/temp_user_login/register_firebase_logic.dart';
import 'package:e_commerce_ui_1/user_logics/login_logic.dart';
import 'package:flutter/material.dart';

class UserUpdate extends StatefulWidget {
  const UserUpdate({super.key});

  @override
  State<UserUpdate> createState() => _UserUpdateState();
}

class _UserUpdateState extends State<UserUpdate> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Details'),
      ),
      body: Column(
        children: [
          RegisterUserName(userNameController: _nameController),
          LoginAndRegisterPhoneFormField(
              definePhoneController: _phoneController),
          ElevatedButton(
            onPressed: () {
              _authService.updateUsernameAndPhone(
                _phoneController.text,
                _nameController.text,
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
