import 'package:e_commerce_ui_1/temp_user_login/register_firebase_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Constants/routes/routes.dart';
import '../user_logics/login_logic.dart';

class UserLoginTemp extends StatefulWidget {
  const UserLoginTemp({super.key});

  @override
  State<UserLoginTemp> createState() => _UserLoginTempState();
}

class _UserLoginTempState extends State<UserLoginTemp> {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              LoginAndRegisterEmailFormField(
                defineEmailController: _loginEmailController,
              ),
              LoginAndRegisterPasswordFormField(
                passwordController: _loginPasswordController,
              ),
              LoginAndRegisterSubmitButton(
                yourText: 'Login',
                yourFunction: () async {
                  User? user = await _authService.logIn(
                      _loginEmailController.text, _loginPasswordController.text);

                  if (user != null) {
                    user.reload().then(
                        (value) => Navigator.pushNamed(context, homeRoute));
                  } else {
                    user?.reload().then(
                        (value) => Navigator.pushNamed(context, loginRoute));
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Don't have an Account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: 'Create here',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, registerRoute);
                          },
                        style: const TextStyle(color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
