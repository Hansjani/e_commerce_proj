import 'package:e_commerce_ui_1/temp_user_login/register_firebase_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../Constants/routes/routes.dart';
import '../user_logics/login_logic.dart';

class RegisterPageTemp extends StatelessWidget {
  const RegisterPageTemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: const UserRegisterTemp(),
    );
  }
}

class UserRegisterTemp extends StatefulWidget {
  const UserRegisterTemp({super.key});

  @override
  State<UserRegisterTemp> createState() => _UserRegisterTempState();
}

class _UserRegisterTempState extends State<UserRegisterTemp> {
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final GlobalKey<FormState> registerForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      key: registerForm,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LoginAndRegisterEmailFormField(
                defineEmailController: _registerEmailController,
              ),
              LoginAndRegisterPhoneFormField(
                definePhoneController: _phoneNumberController,
              ),
              RegisterPasswordAndConfirmPasswordFormField(
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
              ),
              LoginAndRegisterSubmitButton(
                yourText: 'register',
                yourFunction: () async {
                  if (registerForm.currentState!.validate()) {
                    User? user = await _authService.logUp(
                      _registerEmailController.text,
                      _confirmPasswordController.text,
                    );
                    if (user != null) {
                      devtools.log(user.toString());
                      user.reload().then(
                          (value) => Navigator.pushNamedAndRemoveUntil(context, homeRoute,(route) => false,));
                    } else {
                      devtools.log('retry');
                      user?.reload().then(
                          (value) => Navigator.pushNamedAndRemoveUntil(context, loginRoute,(route) => false,));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
