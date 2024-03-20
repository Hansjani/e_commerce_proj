import 'package:e_commerce_ui_1/Constants/shop_item_images.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;
import 'package:e_commerce_ui_1/temp_user_login/temp_img_handle.dart';

class ImageDialog extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onUpdateProfilePicture;
  final ImgHandle imgHandle = ImgHandle();

  ImageDialog({super.key, required this.imageUrl, this.onUpdateProfilePicture});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                height: 350,
                width: 350,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        right: BorderSide(color: Colors.black)),
                                  ),
                                  height: 40,
                                  child: const Icon(
                                    Icons.delete,
                                  ),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await imgHandle
                                      .removeProfilePicture()
                                      .then((_) {
                                    onUpdateProfilePicture?.call();
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Container(
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                          left:
                                              BorderSide(color: Colors.black))),
                                  child: const Icon(
                                    Icons.edit,
                                  ),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  XFile? image =
                                      await imgHandle.chooseProfilePhoto();
                                  if (image != null) {
                                    devtools
                                        .log('Image selected:${image.path}');
                                    String? url = await imgHandle
                                        .uploadProfileImage(image);
                                    if (url != null) {
                                      devtools.log(
                                          'Image successfully uploaded URL: $url');
                                      await imgHandle.saveProfilePhotoUrl(url);
                                      onUpdateProfilePicture?.call();
                                    } else {
                                      devtools.log('Error uploading image');
                                    }
                                  } else {
                                    devtools.log('No image selected');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(),
        ),
        child: ClipOval(
          child: FadeInImage.assetNetwork(
            image: imageUrl!,
            fit: BoxFit.cover,
            placeholder: 'images/replacement.jpeg',
          ),
        ),
      ),
    );
  }
}

class ImageDialogNull extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onUpdateProfilePicture;
  final ImgHandle imgHandle = ImgHandle();

  ImageDialogNull(
      {super.key, required this.imageUrl, this.onUpdateProfilePicture});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                height: 350,
                width: 350,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: replaceImage,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        right: BorderSide(color: Colors.black)),
                                  ),
                                  height: 40,
                                  child: const Icon(
                                    Icons.delete,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Dialog(
                                        child: Text(
                                            'Please select an image for profile'),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Container(
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                          left:
                                              BorderSide(color: Colors.black))),
                                  child: const Icon(
                                    Icons.edit,
                                  ),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  XFile? image =
                                      await imgHandle.chooseProfilePhoto();
                                  if (image != null) {
                                    devtools
                                        .log('Image selected:${image.path}');
                                    String? url = await imgHandle
                                        .uploadProfileImage(image);
                                    if (url != null) {
                                      devtools.log(
                                          'Image successfully uploaded URL: $url');
                                      await imgHandle.saveProfilePhotoUrl(url);
                                      onUpdateProfilePicture?.call();
                                    } else {
                                      devtools.log('Error uploading image');
                                    }
                                  } else {
                                    devtools.log('No image selected');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(),
        ),
        child: ClipOval(
          child: FadeInImage(
            image: replaceImage,
            fit: BoxFit.cover,
            placeholder: replaceImage,
          ),
        ),
      ),
    );
  }
}
