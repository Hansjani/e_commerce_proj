import 'package:e_commerce/Constants/shop_item_images.dart';
import 'package:flutter/material.dart';

class IceCreamConesPage extends StatefulWidget {
  const IceCreamConesPage({super.key});

  @override
  State<IceCreamConesPage> createState() => _IceCreamConesPageState();
}

class _IceCreamConesPageState extends State<IceCreamConesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flavours'),
      ),
      body: const IceCreamCones(),
    );
  }
}

class IceCreamCones extends StatefulWidget {
  const IceCreamCones({super.key});

  @override
  State<IceCreamCones> createState() => _ICeCreamConesState();
}

class _ICeCreamConesState extends State<IceCreamCones> {
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
