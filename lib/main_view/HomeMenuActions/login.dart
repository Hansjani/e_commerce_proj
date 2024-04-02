import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/APIs/UserAPI/user_action_api.dart';
import 'package:e_commerce_ui_1/Constants/routes/routes.dart';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Constants/SharedPreferences/key_names.dart';
import '../../user_logics/login_logic.dart';

class UserLoginMain extends StatefulWidget {
  final AuthProvider authProvider;

  const UserLoginMain({super.key, required this.authProvider});

  @override
  State<UserLoginMain> createState() => _UserLoginMainState();
}

class _UserLoginMainState extends State<UserLoginMain> {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            leading: IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, mainPageRoute, (route) => false);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Form(
                key: loginForm,
                autovalidateMode: AutovalidateMode.disabled,
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
                      yourFunction: () {
                        FocusScope.of(context).unfocus();
                        _login();
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
          ),
        ),
        if (_isLoading)
          ModalBarrier(
            color: Colors.black.withOpacity(0.5),
            dismissible: false,
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    await UserActionAPI().userLogin(
      _loginEmailController.text,
      _loginPasswordController.text,
      (success) {
        onSuccess(context, success, () async {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          final prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString(PrefsKeys.userToken);
          authProvider.login(token).then((value) =>
              Navigator.pushNamedAndRemoveUntil(
                  context, mainPageRoute, (route) => false));
        });
      },
      (error) {
        onError(context, error);
      },
    );
    setState(() {
      _isLoading = false;
    });
  }
}
