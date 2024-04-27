import 'package:e_commerce_ui_1/APIs/AdminActionAPI/item_management_api.dart';
import 'package:e_commerce_ui_1/main_view/Billing/generate_bill_pdf.dart';
import 'package:e_commerce_ui_1/main_view/Providers/cart_provider.dart';
import 'package:flutter/material.dart';

class BillMainView extends StatelessWidget {
  const BillMainView({
    super.key,
    required this.cartItems,
    required this.items,
    required this.orderId,
  });

  final List<CartItem> cartItems;
  final List<Item> items;
  final int orderId;

  double calculateGrandTotal() {
    double grandTotal = 0;
    for (int index = 0; index < cartItems.length; index++) {
      double totalOfOneItem = cartItems[index].productQuantity *
          double.parse(items[index].productPrice);
      grandTotal += totalOfOneItem;
    }
    return grandTotal;
  }

  @override
  Widget build(BuildContext context) {
    String? username = cartItems.isNotEmpty
        ? cartItems[0].username ?? 'Guest User'
        : 'Guest User';
    final List<String> itemName =
        items.map((item) => item.productName).toList();
    final List<int> itemId =
        items.map((item) => int.parse(item.productId)).toList();
    final List<double> itemPrice =
        items.map((item) => double.parse(item.productPrice)).toList();
    final List<int> itemQuantity =
        cartItems.map((item) => item.productQuantity).toList();
    double grandTotal = calculateGrandTotal();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill View'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(), // Add bottom border
                        ),
                      ), // Adjust padding as needed
                      child: Text(
                        'Customer: $username',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FixedColumnWidth(55),
                        1: FixedColumnWidth(100),
                        2: FixedColumnWidth(75),
                        3: FixedColumnWidth(90),
                        4: FixedColumnWidth(100),
                      },
                      children: [
                        const TableRow(
                          children: [
                            TableCell(child: Center(child: Text('Item Id'))),
                            TableCell(child: Center(child: Text('Item Name'))),
                            TableCell(child: Center(child: Text('Item Price'))),
                            TableCell(
                                child: Center(child: Text('Item Quantity'))),
                            TableCell(
                                child: Center(child: Text('Total Amount'))),
                          ],
                        ),
                        for (int index = 0;
                            index < itemName.length;
                            index++) ...{
                          TableRow(
                            children: [
                              TableCell(
                                  child: Center(
                                      child: Text(itemId[index].toString()))),
                              TableCell(
                                  child: Center(
                                      child: Text(itemName[index].toString()))),
                              TableCell(
                                  child: Center(
                                      child:
                                          Text(itemPrice[index].toString()))),
                              TableCell(
                                  child: Center(
                                      child: Text(
                                          itemQuantity[index].toString()))),
                              TableCell(
                                child: Center(
                                  child: Text(
                                      (itemPrice[index] * itemQuantity[index])
                                          .toStringAsFixed(2)),
                                ),
                              ),
                            ],
                          ),
                        }
                      ],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        ' Grand Total: ${grandTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              DownloadBill.downloadBillPDF(orderId);
            },
            child: const Text('Generate bill'),
          ),
        ],
      ),
    );
  }
}
