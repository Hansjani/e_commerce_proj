import 'dart:convert';
import 'dart:developer';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Constants/placeholders.dart';

class ImgHandle {
  Future<XFile?> chooseProfilePhoto() async {
    final ImagePicker photo = ImagePicker();
    final XFile? profilePhoto =
        await photo.pickImage(source: ImageSource.gallery);

    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: profilePhoto!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ], uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
    ]);
    if (croppedFile != null) {
      return XFile(croppedFile.path);
    } else {
      return null;
    }
  }

  Future<String?> uploadProfileImage(XFile? image) async {
    if (image == null) {
      return null;
    }
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    if (token != null) {
      try {
        Uri url = Uri.parse(
            'http://${PlaceHolderImages.ip}/app_db/Rgistered_user_actions/update_profile_image.php?token=$token');
        final request = http.MultipartRequest('POST', url);
        request.files
            .add(await http.MultipartFile.fromPath('file', image.path));
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          String jsonResponse = jsonDecode(responseBody)['message'];
          return jsonResponse;
        } else {
          String jsonResponse = jsonDecode(responseBody)['error'];
          return jsonResponse;
        }
      } catch (e) {
        log('Error uploading image: $e');
      }
    }
    return null;
  }

  Future<void> saveProfilePhotoUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    if (token != null) {
      await prefs.setString(PrefsKeys.userProfile, url);
    }
  }

  Future<String?> getCurrentUrl() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    if (token != null) {
      try {
        Uri url = Uri.parse(
            'http://${PlaceHolderImages.ip}/app_db/Rgistered_user_actions/update_profile_image.php?token=$token');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          String imgUrl = jsonResponse['imageUrl'] ?? 'null';
          await prefs.setString(PrefsKeys.userProfile, imgUrl);
          return imgUrl;
        } else {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          String error = jsonResponse['error'];
          return error;
        }
      } catch (e) {
        log('Error getting URL: $e}');
      }
    } else {
      return null;
    }
    return null;
  }

  Future<void> removeProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    if (token != null) {
      try {
        Uri url = Uri.parse(
            'http://${PlaceHolderImages.ip}/app_db/Rgistered_user_actions/update_profile_image.php?token=$token');
        final response = await http.delete(url);
        if (response.statusCode == 200) {
          String jsonResponse = jsonDecode(response.body)['imageUrl'] ?? 'null';
          await prefs.setString(PrefsKeys.userProfile, jsonResponse);
        } else {
          Map<String,dynamic> jsonResponse = jsonDecode(response.body);
          String imgUrl = jsonResponse['imageUrl'] ?? 'null';
          await prefs.setString(PrefsKeys.userProfile, imgUrl);
        }
      } catch (e) {
        log('Error deleting profile picture: $e');
      }
    }
  }
}
