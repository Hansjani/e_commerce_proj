import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;
import 'package:e_commerce_ui_1/temp_user_login/temp_img_handle.dart';

class ImageDialogTest extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onUpdateProfilePicture;
  final ImgHandle imgHandle = ImgHandle();

  ImageDialogTest({super.key, this.imageUrl, this.onUpdateProfilePicture});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Stack(
                children: [
                  if (imageUrl != null)
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.7,
                    )
                  else
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.7,
                      color: Colors.grey, // Placeholder color
                      child: const Center(
                        child: Text(
                          'Image not available',
                          style: TextStyle(color: Colors.white),
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
                                height: 40,
                                color: Colors.white.withOpacity(0.7),
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
                                color: Colors.white.withOpacity(0.7),
                                child: const Icon(
                                  Icons.edit,
                                ),
                              ),
                              onTap: () async {
                                Navigator.pop(context);
                                XFile? image =
                                await imgHandle.chooseProfilePhoto();
                                if (image != null) {
                                  devtools.log('Image selected:${image.path}');
                                  String? url =
                                  await imgHandle.uploadProfileImage(image);
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
            image: imageUrl ?? '', // Use a placeholder image or set to null
            fit: BoxFit.cover,
            placeholder: 'images/replacement.jpeg',
          ),
        ),
      ),
    );
  }
}
