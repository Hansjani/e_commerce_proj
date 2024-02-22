import 'package:e_commerce/Constants/shop_item_images.dart';
import 'package:flutter/material.dart';

class IceCreamCupPage extends StatefulWidget {
  const IceCreamCupPage({super.key});

  @override
  State<IceCreamCupPage> createState() => _IceCreamCupPageState();
}

class _IceCreamCupPageState extends State<IceCreamCupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flavours'),
      ),
      body: const IceCreamCup(),
    );
  }
}

class IceCreamCup extends StatefulWidget {
  const IceCreamCup({super.key});

  @override
  State<IceCreamCup> createState() => _IceCreamCupState();
}

class _IceCreamCupState extends State<IceCreamCup> {
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
