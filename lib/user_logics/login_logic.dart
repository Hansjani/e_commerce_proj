import 'package:e_commerce_ui_1/APIs/UserAPI/user_action_api.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginAndRegisterPasswordFormField extends StatefulWidget {
  final TextEditingController _passwordController;

  const LoginAndRegisterPasswordFormField(
      {super.key, required TextEditingController passwordController})
      : _passwordController = passwordController;

  @override
  State<LoginAndRegisterPasswordFormField> createState() =>
      _LoginAndRegisterPasswordFormFieldState();
}

class _LoginAndRegisterPasswordFormFieldState
    extends State<LoginAndRegisterPasswordFormField> {
  _LoginAndRegisterPasswordFormFieldState();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: 'Password',
          prefixIcon: const Icon(Icons.password),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                if (_isObscure) {
                  _isObscure = false;
                } else {
                  _isObscure = true;
                }
              });
            },
            icon: _isObscure
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
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
      controller: widget._passwordController,
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}

class RegisterUserName extends StatefulWidget {
  final TextEditingController _defineUserNameController;

  const RegisterUserName(
      {super.key, required TextEditingController userNameController})
      : _defineUserNameController = userNameController;

  @override
  State<RegisterUserName> createState() => _RegisterUserNameState();
}

class _RegisterUserNameState extends State<RegisterUserName> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: 'Username',
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter username';
        }
        return null;
      },
      controller: widget._defineUserNameController,
      autocorrect: true,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class RegisterPasswordAndConfirmPasswordFormField extends StatefulWidget {
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;

  const RegisterPasswordAndConfirmPasswordFormField(
      {super.key,
      required TextEditingController passwordController,
      required TextEditingController confirmPasswordController})
      : _confirmPasswordController = confirmPasswordController,
        _passwordController = passwordController;

  @override
  State<RegisterPasswordAndConfirmPasswordFormField> createState() =>
      _RegisterPasswordAndConfirmPasswordFormFieldState();
}

class _RegisterPasswordAndConfirmPasswordFormFieldState
    extends State<RegisterPasswordAndConfirmPasswordFormField> {
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            obscureText: _isObscure,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Password',
              prefixIcon: const Icon(Icons.password),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(
                    () {
                      if (_isObscure) {
                        _isObscure = false;
                      } else {
                        _isObscure = true;
                      }
                    },
                  );
                },
                icon: _isObscure
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              ),
            ),
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
            controller: widget._passwordController,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            obscureText: _isConfirmObscure,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Confirm Password',
              prefixIcon: const Icon(Icons.password),
              suffixIcon: IconButton(
                icon: _isConfirmObscure
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
                onPressed: () {
                  setState(
                    () {
                      if (_isConfirmObscure) {
                        _isConfirmObscure = false;
                      } else {
                        _isConfirmObscure = true;
                      }
                    },
                  );
                },
              ),
            ),
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
              } else if (value != widget._passwordController.text) {
                return 'Password does not match';
              }
              return null;
            },
            controller: widget._confirmPasswordController,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
          ),
        ),
      ],
    );
  }
}

class LoginAndRegisterEmailFormField extends StatelessWidget {
  const LoginAndRegisterEmailFormField({
    super.key,
    required TextEditingController defineEmailController,
  }) : _defineEmailController = defineEmailController;

  final TextEditingController _defineEmailController;

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
        } else if (value == 'hello') {
          return 'write something else please';
        }
        return null;
      },
      controller: _defineEmailController,
      autocorrect: true,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class LoginAndRegisterPhoneFormField extends StatelessWidget {
  const LoginAndRegisterPhoneFormField({
    super.key,
    required TextEditingController definePhoneController,
  }) : _definePhoneController = definePhoneController;

  final TextEditingController _definePhoneController;

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
        } else if (value.length != 10) {
          return 'This field must have only 10 characters';
        }
        return null;
      },
      controller: _definePhoneController,
      autocorrect: true,
      keyboardType: TextInputType.number,
    );
  }
}

class RegisterMerchantField extends StatefulWidget {
  const RegisterMerchantField({super.key});

  @override
  State<RegisterMerchantField> createState() => _RegisterMerchantFieldState();
}

class _RegisterMerchantFieldState extends State<RegisterMerchantField> {
  final List<String> _companies = ['-- companies --'];
  String _initialCompany = '-- companies --';

  @override
  void initState() {
    UserActionAPI().getCompanies().then((values) {
      setState(() {
        _companies.addAll(values);
      });
    }).catchError((error) {
      print(error);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: _initialCompany,
        items: _companies.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newCompany) {
          setState(() {
            _initialCompany = newCompany!;
          });
        },
      ),
    );
  }
}

class LoginAndRegisterSubmitButton extends StatelessWidget {
  final String _yourText;
  final VoidCallback _yourFunction;

  const LoginAndRegisterSubmitButton(
      {super.key,
      required String yourText,
      required void Function() yourFunction})
      : _yourFunction = yourFunction,
        _yourText = yourText;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: _yourFunction,
      child: Text(_yourText),
    );
  }
}
