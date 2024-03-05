import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImgHandle {
  Future<XFile?> chooseProfilePhoto() async {
    final ImagePicker photo = ImagePicker();
    final XFile? profilePhoto =
        await photo.pickImage(source: ImageSource.gallery);
    return profilePhoto;
  }

  Future<String?> uploadProfileImage(XFile? image) async {
    if (image == null) {
      return null;
    }
    String? currentUrl = await getCurrentUrl();
    if(currentUrl != null){
      try{
        FirebaseStorage.instance.refFromURL(currentUrl).delete().then((value) => log('deleted previous image'));
      }catch(e){
        log('Error deleting previous image: $e');
      }
    }

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage
        .ref()
        .child("profile_photos/${DateTime.now().millisecondsSinceEpoch}");
    UploadTask uploadTask = reference.putFile(File(image.path));

    await uploadTask;

    String downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveProfilePhotoUrl(String url) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePhotoUrl': url,
      });
    }
  }

  Future<String?> getCurrentUrl() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if(userId != null){
      try{
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if(snapshot.exists && snapshot.data() !=null && snapshot.data()!.containsKey('profilePhotoUrl')){
          return snapshot.data()!['profilePhotoUrl'];
        }else{
          return null;
        }
      }catch (e){
        log('Error getting URL: $e}');
      }
    }else{
      return null;
    }
    return null;
  }
  Future<void> removeProfilePicture() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if(userId != null){
      try{
        String? currentUrl = await getCurrentUrl();
        if(currentUrl != null){
          await FirebaseStorage.instance.refFromURL(currentUrl).delete();
          log('Removed image');
        }
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
            {
              'profilePhotoUrl' : FieldValue.delete(),
            });
        log('Removed URL');
      }catch(e){
        log('Error deleting profile picture: $e');
      }
    }
  }
}
