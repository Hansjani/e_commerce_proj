import 'package:e_commerce/Constants/shop_item_images.dart';
import 'package:flutter/material.dart';

class IceCreamTubPage extends StatefulWidget {
  const IceCreamTubPage({super.key});

  @override
  State<IceCreamTubPage> createState() => _IceCreamTubPageState();
}

class _IceCreamTubPageState extends State<IceCreamTubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flavours'),
      ),
      body: const IceCreamTub(),
    );
  }
}

class IceCreamTub extends StatefulWidget {
  const IceCreamTub({super.key});

  @override
  State<IceCreamTub> createState() => _IceCreamTubState();
}

class _IceCreamTubState extends State<IceCreamTub> {
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
