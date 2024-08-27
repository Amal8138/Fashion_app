import 'package:fashion/Screens/user/Widgets/all_order_widget.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';

class ScreenAllOrders extends StatefulWidget {
  const ScreenAllOrders({super.key});

  @override
  _ScreenAllOrdersState createState() => _ScreenAllOrdersState();
}

class _ScreenAllOrdersState extends State<ScreenAllOrders> {
  late Future<List<OrderItemsModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    _ordersFuture = fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('All Orders', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<OrderItemsModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            final orders = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _loadOrders();
                });
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return buildOrderCard(order,context);
                },
              ),
            );
          }
        },
      ),
    );
  }
}