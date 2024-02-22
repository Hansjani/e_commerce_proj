import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Constants/routes/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const RegisterForm();
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

bool _isObscureRegister = true;
IconData iconsRegister = Icons.visibility;

class _RegisterFormState extends State<RegisterForm> {
  late final TextEditingController registerEmailController;
  late final TextEditingController registerPasswordController;

  @override
  void initState() {
    registerEmailController = TextEditingController();
    registerPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    registerEmailController.dispose();
    registerPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      autovalidateMode: AutovalidateMode.always,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 5.0),
                      child: Text('Hi, Welcome back!'),
                    ),
                    Icon(Icons.waving_hand),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'We are happy to see you',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 8.0,
                              bottom: 4.0,
                            ),
                            child: Text('Email'),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.5,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email address';
                          } else if (EmailValidator.validate(value) == false) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                        controller: registerEmailController,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 8.0,
                              bottom: 4.0,
                            ),
                            child: Text('Password'),
                          ),
                        ],
                      ),
                      TextFormField(
                        autocorrect: false,
                        obscureText: _isObscureRegister,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  if (_isObscureRegister == true) {
                                    _isObscureRegister = false;
                                    iconsRegister = Icons.visibility_off;
                                  } else {
                                    _isObscureRegister = true;
                                    iconsRegister = Icons.visibility;
                                  }
                                },
                              );
                            },
                            icon: Icon(iconsRegister),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.5,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          } else if (value.length < 8) {
                            return 'Password length must be at least 8 characters';
                          } else if (value.contains(RegExp(r'[A-Z]')) ==
                              false) {
                            return 'Password must contain at least one Uppercase letter';
                          } else if (value.contains(RegExp(r'[a-z]')) ==
                              false) {
                            return 'Password must contain at least contain one Lowercase letter';
                          } else if (value.contains(RegExp(r'[0-9]')) ==
                              false) {
                            return 'Password must contain at least one digit';
                          }
                          return null;
                        },
                        controller: registerPasswordController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 250,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Register'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Already have account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: 'Sign In Here',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, loginRoute);
                          },
                        style: const TextStyle(color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 10,
                        ),
                        child: const Divider(),
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        text: 'Or Sign In With',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 20,
                        ),
                        child: const Divider(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.g_mobiledata_rounded),
                  onPressed: () {},
                  label: const Text('Continue with Google'),
                ),
              ),
              SizedBox(
                width: 300,
                child: RichText(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'By signing up you agree to our ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: 'Terms ',
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        style: const TextStyle(color: Colors.deepPurple),
                      ),
                      const TextSpan(
                        text: 'and ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: 'Conditions of Use.',
                        recognizer: TapGestureRecognizer()..onTap = () {},
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
