import 'dart:io';
import 'dart:typed_data';
import 'package:fashion/Screens/admin/pages/order_details.dart';
import 'package:flutter/material.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ScreenAdminAllOrders extends StatelessWidget {
  const ScreenAdminAllOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<OrderItemsModel>>(
        future: fetchAllOrdersDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            final orders = snapshot.data!;
            return FutureBuilder<List<UserSignUpModels>>(
              future: fetchAllUserDetails(), 
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error: ${userSnapshot.error}'));
                } else if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found.'));
                } else {
                  final users = userSnapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final user = users.firstWhere(
                        (user) => user.userId == order.user.userId,
                        orElse: () => UserSignUpModels(
                          userId: 'Unknown',
                          userName: 'Unknown',
                          userPhone: 'Unknown',
                          userAddress: 'Unknown',
                          userGender: 'Unknown',
                          userImage: Uint8List(0),
                          houseName: 'Unknown',
                          houseNumber: 'Unknown',
                          locality: 'Unknown'
                        ),
                      );

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ScreenOrderDetailsAdmin(order: order, user: user)));
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: kIsWeb ? Image.network(order.product.productImages.first,fit: BoxFit.cover,height: 80,width: 80,)
                                  : Image.file(
                                    File(order.product.productImages.first),
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.product.productName,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '\$${order.product.productPrice}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'User: ${user.userName}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Date: ${order.dateTime}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const SizedBox(height: 8,),
                                      Text(
                                  _getStatusText(order.status),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: _getStatusColor(order.status),
                                  ),
                                ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Status: Confirmed';
      case OrderStatus.inTransit:
        return 'Status: In Transit';
      case OrderStatus.delivered:
        return 'Status: Delivered';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return Colors.orange;
      case OrderStatus.inTransit:
        return Colors.yellow;
      case OrderStatus.delivered:
        return Colors.green;
    }
  }
}
