import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/APIs/UserAPI/user_action_api.dart';
import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:flutter/material.dart';
import '../../user_logics/login_logic.dart';

class RegisterPageMain extends StatelessWidget {
  final AuthProvider authProvider;

  const RegisterPageMain({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: UserRegisterMain(
        authProvider: authProvider,
      ),
    );
  }
}

class UserRegisterMain extends StatefulWidget {
  final AuthProvider authProvider;

  const UserRegisterMain({super.key, required this.authProvider});

  @override
  State<UserRegisterMain> createState() => _UserRegisterMainState();
}

class _UserRegisterMainState extends State<UserRegisterMain> {
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final List<String> _companies = ['-- companies --'];
  String _initialCompany = '-- companies --';
  bool _isMerchant = false;
  final GlobalKey<FormState> registerForm = GlobalKey<FormState>();

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
    final authProvider = widget.authProvider;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, mainPageRoute, (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: registerForm,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoginAndRegisterEmailFormField(
                    defineEmailController: _registerEmailController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RegisterUserName(
                    userNameController: _usernameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoginAndRegisterPhoneFormField(
                    definePhoneController: _phoneController,
                  ),
                ),
                RegisterPasswordAndConfirmPasswordFormField(
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                ),
                CheckboxListTile(
                  value: _isMerchant,
                  title: const Text('Register as merchant ?'),
                  onChanged: (bool? value) {
                    setState(() {
                      _isMerchant = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (_isMerchant) ...[
                  DropdownButton<String>(
                    value: _initialCompany,
                    items: _companies
                        .map<DropdownMenuItem<String>>((String value) {
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
                ],
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoginAndRegisterSubmitButton(
                      yourText: 'register',
                      yourFunction: () {
                        UserActionAPI().registerUser(
                            _isMerchant ? _initialCompany : '',
                            _usernameController.text,
                            _passwordController.text,
                            _registerEmailController.text,
                            int.parse(_phoneController.text),
                            _isMerchant ? 'merchant' : 'customer', (success) {
                          onSuccess(
                            context,
                            success!,
                            () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, mainPageRoute, (route) => false);
                            },
                          );
                        }, (error) {
                          onError(context, error!);
                        }, authProvider);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
