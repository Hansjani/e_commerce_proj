import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_get_users_api.dart';
import 'package:e_commerce_ui_1/APIs/OrderAPI/see_orders.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/Orders/merchant_action_on_order_items.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/MerchantOptions/merchant_options.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Constants/SharedPreferences/key_names.dart';

class AllOrdersForCompany extends StatefulWidget {
  const AllOrdersForCompany({super.key});

  @override
  State<AllOrdersForCompany> createState() => _AllOrdersForCompanyState();
}

class _AllOrdersForCompanyState extends State<AllOrdersForCompany> {
  late Future<String?> userCompany;

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(PrefsKeys.userName);
    if (username != null) {
      Users? user = await UserCRUD().getByUsername(username);
      return user?.userCompany;
    }
    return null;
  }

  @override
  void initState() {
    userCompany = getUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All orders'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MerchantOptions(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: userCompany,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data != null) {
                String? company = snapshot.data;
                if (company != null) {
                  return FutureBuilder(
                    future: OrderForMerchantAPI().getOrderDetails(company),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      } else {
                        List<OrderForUser?> orderForUser = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: orderForUser.length,
                          itemBuilder: (BuildContext context, int index) {
                            OrderForUser? order = orderForUser[index];
                            List<OrderItemForOrder>? sentOrderItems = order
                                ?.orderItems
                                .where((items) => items.status == 'sent')
                                .toList();
                            return ListTile(
                              leading: Text('${index + 1}'),
                              title: Text('OrderID #${order?.orderId}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Order items count : ${order?.orderItems.length}'),
                                  Text('Order items sent : ${sentOrderItems?.length}'),
                                  Text('Order status : ${order!.orderStatus}'),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderActionByMerchant(
                                      orderId: order.orderId,
                                      company: company,
                                      orderItems: order.orderItems,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  );
                } else {
                  return const Center(child: Text('No company for user'));
                }
              } else {
                return const Center(
                  child: Text('No data for user'),
                );
              }
            default:
              return const LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
