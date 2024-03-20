import 'package:flutter/material.dart';

class PhotoItems extends StatelessWidget {
  final String imageDescription;
  final String photoImage;
  final VoidCallback navigationFunction;

  const PhotoItems(
      {super.key,
      required this.imageDescription,
      required this.photoImage,
      required this.navigationFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigationFunction,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 3,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                photoImage,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 30,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  imageDescription,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PhotoItemsTwo extends StatelessWidget {
  final String imageDescription;
  final ImageProvider photoImage;
  final VoidCallback navigationFunction;

  const PhotoItemsTwo(
      {super.key,
        required this.imageDescription,
        required this.photoImage,
        required this.navigationFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigationFunction,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 3,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image(
                image: photoImage,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 30,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  imageDescription,
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

