import 'dart:developer';

import 'package:flutter/material.dart';

class PhotoItems extends StatefulWidget {
  final String imageDescription;
  final String photoImage;
  final VoidCallback navigationFunction;

  const PhotoItems(
      {super.key,
      required this.imageDescription,
      required this.photoImage,
      required this.navigationFunction});

  @override
  State<PhotoItems> createState() => _PhotoItemsState();
}

class _PhotoItemsState extends State<PhotoItems> {
  Key imageKey = UniqueKey();

  void retryLoadingImage() {
    setState(() {
      imageKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.navigationFunction,
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
                widget.photoImage,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        const Text('Failed to load data'),
                        TextButton(
                          onPressed: retryLoadingImage,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.imageDescription,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
