import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/placeholders.dart';


class TokenManager {
  late Timer _timer;
  static const Duration checkInterval = Duration(seconds: 30);

  TokenManager() {
    startTokenExpirationCheck();
  }

  // void expireToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString(PrefsKeys.userToken);
  //
  //   if (token != null) {
  //     log(token);
  //     List<String> tokenParts = token.split('.');
  //     String payload = tokenParts[1];
  //     String decodedPayload = utf8.decode(base64Url.decode(payload));
  //     Map<String, dynamic> payloadJson = jsonDecode(decodedPayload);
  //     int expiryTime = payloadJson['exp'];
  //     DateTime expiryDateTime =
  //         DateTime.fromMillisecondsSinceEpoch(expiryTime * 1000);
  //     DateTime now = DateTime.now();
  //     if (now.isAfter(expiryDateTime)) {
  //       log('token is expired');
  //       logOutUser();
  //       navigateToSignInPage();
  //     } else {
  //       Duration remainingTime = expiryDateTime.difference(now);
  //       if (remainingTime < const Duration(minutes: 10)) {
  //         refreshToken(token);
  //       } else {
  //         log('token is valid for : $remainingTime');
  //       }
  //     }
  //   } else {
  //     log('token not found');
  //   }
  // }

  void startTokenExpirationCheck() {
    _timer = Timer.periodic(checkInterval, (Timer timer) async {
      // expireToken();
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void refreshToken(String token) async {
    String jsonBody = jsonEncode({
      "token": token,
    });
    final response = await http.post(
      Uri.parse('http://${PlaceHolderImages.ip}/app_db/Admin_actions/token_refresh.php'),
      body: jsonBody,
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      String newToken = jsonResponse['token'];
      log('new : $newToken');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('userToken', newToken);
    } else {
      String error = jsonDecode(response.body)['error'];
      log(error);
    }
  }

  // void navigateToSignInPage() {
  //   navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
  //     builder: (context) => UserLoginMain(),
  //   ));
  // }
}
