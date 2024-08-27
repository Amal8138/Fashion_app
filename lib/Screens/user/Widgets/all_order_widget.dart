import 'dart:io';
import 'package:fashion/Screens/user/pages/order_detail.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

Widget buildOrderCard(OrderItemsModel order , BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ScreenOrderDetailsUser(order: order),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              buildOrderImage(order.product.productImages.first),
              const SizedBox(width: 12.0),
              buildOrderDetails(order),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderImage(String imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: kIsWeb ? NetworkImage(imageUrl) : FileImage(File(imageUrl)) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildOrderDetails(OrderItemsModel order) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.product.productName,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            '\$${order.product.productPrice}',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Date: ${order.dateTime}',
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            getStatusText(order.status),
            style: TextStyle(
              fontSize: 14.0,
              color: getStatusColor(order.status),
            ),
          ),
        ],
      ),
    );
  }

String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Status: Confirmed';
      case OrderStatus.inTransit:
        return 'Status: In Transit';
      case OrderStatus.delivered:
        return 'Status: Delivered';
    }
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return Colors.orange;
      case OrderStatus.inTransit:
        return Colors.yellow;
      case OrderStatus.delivered:
        return Colors.green;
    }
  }