import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

class ScreenOrderDetailsAdmin extends StatefulWidget {
  final OrderItemsModel order;
  final UserSignUpModels user;

  const ScreenOrderDetailsAdmin({
    super.key,
    required this.order,
    required this.user,
  });

  @override
  _ScreenOrderDetailsAdminState createState() =>
      _ScreenOrderDetailsAdminState();
}

class _ScreenOrderDetailsAdminState extends State<ScreenOrderDetailsAdmin> {
  late OrderStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
  }

  Future<void> _updateOrderStatus(OrderStatus newStatus) async {
    var orderBox = await Hive.openBox<OrderItemsModel>('orderBox');

    final orderKey = orderBox.keys.firstWhere(
      (key) => orderBox.get(key) == widget.order,
      orElse: () => null,
    );

    if (orderKey != null) {
      final updatedOrder = widget.order.copyWith(status: newStatus);
      await orderBox.put(orderKey, updatedOrder);

      setState(() {
        _currentStatus = newStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice =
        widget.order.product.productPrice * widget.order.quantity;
    final String formattedDate = DateFormat('yyyy-MM-dd').format(widget.order.dateTime);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: kIsWeb ? Image.network(widget.order.product.productImages.first,fit: BoxFit.cover,height: 120,width: 120,)
              : Image.file(
                File(widget.order.product.productImages.first),
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.order.product.productName,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '\$${widget.order.product.productPrice}',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'User: ${widget.user.userName}',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Ordered date: $formattedDate',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Address: ${widget.user.userAddress}',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'House name: ${widget.user.houseName}',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'House Number: ${widget.user.houseNumber}',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Locality: ${widget.user.locality}',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            
            const SizedBox(height: 8.0),
            Text(
              'Phone: ${widget.user.userPhone}',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Product Quantity : ${widget.order.quantity}',
              style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Order Status:',
              style:  TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            DropdownButton<OrderStatus>(
              value: _currentStatus,
              items: OrderStatus.values.map((OrderStatus status) {
                return DropdownMenuItem<OrderStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
              onChanged: (OrderStatus? newStatus) {
                if (newStatus != null) {
                  _updateOrderStatus(newStatus);
                }
              },
            ),
            const SizedBox(height: 16,),
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
