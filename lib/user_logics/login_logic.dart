import 'package:e_commerce/user_logics/login_functions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginAndRegisterPasswordFormField extends StatefulWidget {
  final TextEditingController passwordController = TextEditingController();

  LoginAndRegisterPasswordFormField({super.key});

  @override
  State<LoginAndRegisterPasswordFormField> createState() => _LoginAndRegisterPasswordFormFieldState();
}

class _LoginAndRegisterPasswordFormFieldState extends State<LoginAndRegisterPasswordFormField> {

  _LoginAndRegisterPasswordFormFieldState();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: 'Password',
          prefixIcon: const Icon(Icons.password),
          suffixIcon: IconButton(
            onPressed: passwordIconFunction(),
            icon: const Icon(Icons.visibility),
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password cannot be empty';
        } else if (value.length < 8) {
          return 'Password length must be at least 8 characters';
        } else if (value.contains(RegExp(r'[A-Z]')) == false) {
          return 'Password must contain at least one Uppercase letter';
        } else if (value.contains(RegExp(r'[a-z]')) == false) {
          return 'Password must contain at least contain one Lowercase letter';
        } else if (value.contains(RegExp(r'[0-9]')) == false) {
          return 'Password must contain at least one digit';
        } else if (value != widget.passwordController.text){
          return 'Password does not match';
        }
        return null;
      },
      controller: widget.passwordController,
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}


class RegisterConfirmPasswordFormField extends StatefulWidget {
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterConfirmPasswordFormField({super.key});

  @override
  State<RegisterConfirmPasswordFormField> createState() => _RegisterConfirmPasswordFormFieldState();
}

class _RegisterConfirmPasswordFormFieldState extends State<RegisterConfirmPasswordFormField> {
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isConfirmPasswordObscure,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: 'Password',
          prefixIcon: const Icon(Icons.password),
          suffixIcon: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: (){
                setState(() {
                  confirmPasswordIconFunction();
                });
              }
          )),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password cannot be empty';
        } else if (value.length < 8) {
          return 'Password length must be at least 8 characters';
        } else if (value.contains(RegExp(r'[A-Z]')) == false) {
          return 'Password must contain at least one Uppercase letter';
        } else if (value.contains(RegExp(r'[a-z]')) == false) {
          return 'Password must contain at least contain one Lowercase letter';
        } else if (value.contains(RegExp(r'[0-9]')) == false) {
          return 'Password must contain at least one digit';
        }
        return null;
      },
      controller: widget.confirmPasswordController,
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}

class LoginAndRegisterEmailFormField extends StatelessWidget {
  const LoginAndRegisterEmailFormField({
    super.key,
    required this.defineEmailController,
  });

  final TextEditingController defineEmailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: 'Email Address',
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email address';
        } else if (EmailValidator.validate(value) == false) {
          return 'Please enter valid email';
        }
        return null;
      },
      controller: defineEmailController,
      autocorrect: true,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class LoginAndRegisterPhoneFormField extends StatelessWidget {
  const LoginAndRegisterPhoneFormField({
    super.key,
    required this.definePhoneController,
  });

  final TextEditingController definePhoneController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: 'Phone Number',
        prefixIcon: const Icon(Icons.phone_android),
      ),
      validator: (value) {
        RegExp regex = RegExp(r'^[0-9]+$');
        if (value == null || value.isEmpty) {
          return 'This field cannot remain empty';
        } else if (!regex.hasMatch(value)) {
          return 'This field can only contain numbers';
        }
        return null;
      },
      controller: definePhoneController,
      autocorrect: true,
      keyboardType: TextInputType.number,
    );
  }
}
