import 'package:flutter/material.dart';

bool isObscure = true;
IconData suffixPasswordIcon = Icons.visibility;

passwordIconFunction() {
  if (isObscure = true) {
    suffixPasswordIcon = Icons.visibility_off;
    isObscure = false;
  } else {
    suffixPasswordIcon = Icons.visibility;
    isObscure = true;
  }
}

bool isConfirmPasswordObscure = true;
IconData suffixConfirmPasswordIcon = Icons.visibility;

confirmPasswordIconFunction() {
  if (isConfirmPasswordObscure = true) {
    suffixConfirmPasswordIcon = Icons.visibility_off;
    isConfirmPasswordObscure = false;
  } else {
    suffixConfirmPasswordIcon = Icons.visibility;
    isConfirmPasswordObscure = true;
  }
}
