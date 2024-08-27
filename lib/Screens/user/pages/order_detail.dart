import 'dart:io';
import 'package:fashion/Screens/user/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ScreenOrderDetailsUser extends StatefulWidget {
  final OrderItemsModel order;

  const ScreenOrderDetailsUser({
    super.key,
    required this.order,
  });

  @override
  _ScreenOrderDetailsUserState createState() => _ScreenOrderDetailsUserState();
}

class _ScreenOrderDetailsUserState extends State<ScreenOrderDetailsUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.order.product.productPrice * widget.order.quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                      return ScreenProductDetails(
                        images: widget.order.product.productImages,
                        productType: widget.order.product.productType,
                        productName: widget.order.product.productName,
                        productPrice: widget.order.product.productPrice,
                        productDetails: widget.order.product.productDetails,
                        productSize: widget.order.product.productSize,
                        productId: widget.order.product.productId,
                        productCategory: widget.order.product.productCategory,
                      );
                    }));
                  },
                  child: AspectRatio(
                    aspectRatio: 1, 
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: kIsWeb ? Image.network(widget.order.product.productImages.first,fit: BoxFit.cover,)
                      : Image.file(File(widget.order.product.productImages.first),fit: BoxFit.cover,)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.order.product.productName,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '\$${widget.order.product.productPrice}',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Quantity: ${widget.order.quantity}',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Product Detail',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              Text(
                widget.order.product.productDetails,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Order Date: ${widget.order.dateTime}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                _getStatusText(widget.order.status),
                style: TextStyle(
                  fontSize: 16.0,
                  color: _getStatusColor(widget.order.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
        ),
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
