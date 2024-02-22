import 'package:flutter/material.dart';

class RegisterConfirmPasswordFormField extends StatefulWidget {
  const RegisterConfirmPasswordFormField({super.key});

  @override
  State<RegisterConfirmPasswordFormField> createState() =>
      _RegisterConfirmPasswordFormFieldState();
}

class _RegisterConfirmPasswordFormFieldState
    extends State<RegisterConfirmPasswordFormField> {
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

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
              icon: isObscure
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  if (isObscure) {
                    isObscure = false;
                  } else {
                    isObscure = true;
                  }
                });
              })),
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
      controller: passwordController,
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
