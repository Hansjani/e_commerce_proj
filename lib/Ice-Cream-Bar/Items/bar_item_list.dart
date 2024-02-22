import 'package:e_commerce/Constants/shop_item_images.dart';
import 'package:flutter/material.dart';

class IceCreamBarPage extends StatefulWidget {
  const IceCreamBarPage({super.key});

  @override
  State<IceCreamBarPage> createState() => _IceCreamBarPageState();
}

class _IceCreamBarPageState extends State<IceCreamBarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flavours'),
      ),
      body: const IceCreamBar(),
    );
  }
}


class IceCreamBar extends StatefulWidget {
  const IceCreamBar({super.key});

  @override
  State<IceCreamBar> createState() => _IceCreamBarState();
}

class _IceCreamBarState extends State<IceCreamBar> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: vanilla,
              ),
              title: const Text('Vanilla'),
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: chocolate,
              ),
              title: const Text('Chocolate'),
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: cookies,
              ),
              title: const Text('Cookies and Cream'),
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: chocoChips,
              ),
              title: const Text('Chocolate Chips'),
            ),
          ),
        ),
        SizedBox(
          height: 75,
          child: Center(
            child: ListTile(
              leading: Image(
                image: strawBerry,
              ),
              title: const Text('Strawberry'),
            ),
          ),
        ),
      ],
    );
  }
}
