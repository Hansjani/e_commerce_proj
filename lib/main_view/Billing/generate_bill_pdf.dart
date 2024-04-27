import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_notification_for_app.dart';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class DownloadBill {
  static final Uri _pdfUrl = Uri.parse(
      'http://192.168.29.184/app_db/Rgistered_user_actions/order_management/bill_management.php');

  static Future<void> downloadBillPDF(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    var status = await Permission.storage.request();
    print(status);
    if (status.isGranted) {
      try {
        final response = await http.get(
          _pdfUrl.resolve('?orderId=$orderId'),
          headers: {"Authorization": "Bearer $token"},
        );
        if (response.statusCode == 200) {
          await AppNotifications.showDownloadNotification(
            id: 1, // Notification ID without leading zeros
            title: 'Downloading Bill',
            description: 'Starting download...', progress: 100,
          );

          final fileData = base64Decode(response.body);
          final directory = await getExternalStorageDirectory();
          final downloadDirectory = Directory('${directory!.parent.parent.parent.parent.path}/Download');
          if (!downloadDirectory.existsSync()) {
            downloadDirectory.createSync(recursive: true);
          }
          final filePath = '${downloadDirectory.path}/${orderId}_bill.pdf';
          log(filePath);
          await File(filePath).writeAsBytes(fileData);

          await AppNotifications.cancelNotification(1); // Notification ID without leading zeros
          AppNotifications.completeDownload(id: 2, progress: 100);
        } else {
          log('${response.statusCode} : ${response.body}');
        }
      } catch (e) {
        await AppNotifications.showDownloadNotification(
          id: 3, // Notification ID without leading zeros
          title: 'Download Failed',
          description: 'Failed to download bill',
          progress: 0
        );
        log("error : $e");
      }
    } else {
      log('Permission denied');
    }
  }


  static Future<void> sendDataToMakeBill(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    final response = await http.post(
      _pdfUrl,
      headers: {"Authorization": "Bearer $token"},
      body: jsonEncode(
        {
          "orderId": orderId,
        },
      ),
    );
    if (response.statusCode == 200) {
      log(response.body);
    } else {
      log("${response.statusCode} : ${response.body}");
    }
  }
}
