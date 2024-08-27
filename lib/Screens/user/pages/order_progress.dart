import 'dart:io';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ScreenOrderProgress extends StatefulWidget {
  final List<CartProductModel> cartItems;

  const ScreenOrderProgress({super.key, required this.cartItems});

  @override
  _ScreenOrderProgressState createState() => _ScreenOrderProgressState();
}

class _ScreenOrderProgressState extends State<ScreenOrderProgress> {
  List<UserSignUpModels> _userAddresses = [];
  UserSignUpModels? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _fetchUserAddresses();
  }

  Future<void> _fetchUserAddresses() async {
    var box = Hive.box<UserSignUpModels>('userBox');
    String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;
    setState(() {
      _userAddresses =
          box.values.where((user) => user.userId == loggedInUserId).toList();
      if (_userAddresses.isNotEmpty) {
        _selectedAddress = _userAddresses.first;
      }
    });
  }

  Future<void> _addNewAddress(String newAddress , String houseNumber , String houseName , String locality) async {
    var box = Hive.box<UserSignUpModels>('userBox');
    String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;
    final user = box.values.firstWhere((user) => user.userId == loggedInUserId);

    if (loggedInUserId != null) {
      final newUserAddress = UserSignUpModels(
        userId: loggedInUserId,
        userName: user.userName,
        userPhone: user.userPhone,
        userAddress: newAddress,
        userGender: user.userGender,
        userImage: user.userImage,
        houseName: houseName,
        houseNumber: houseNumber,
        locality: locality
      );

      await box.add(newUserAddress);
      setState(() {
        _userAddresses.add(newUserAddress);
        _selectedAddress = newUserAddress;
      });
    }
  }

  void _showAddAddressDialog() {
  String houseNumber = '';
  String houseName = '';
  String locality = '';
  String userAddress = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add New Address'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (value) => houseNumber = value,
                decoration: const InputDecoration(hintText: "House Number"),
              ),
              TextField(
                onChanged: (value) => houseName = value,
                decoration: const InputDecoration(hintText: "House Name"),
              ),
              TextField(
                onChanged: (value) => locality = value,
                decoration: const InputDecoration(hintText: "Locality"),
              ),
              TextField(
                onChanged: (value) => userAddress = value,
                decoration: const InputDecoration(hintText: "Enter your address"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (houseNumber.isNotEmpty &&
                  houseName.isNotEmpty &&
                  locality.isNotEmpty &&
                  userAddress.isNotEmpty) {
                    _addNewAddress(
                      userAddress, 
                      houseNumber, 
                      houseName, locality
                      );
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add Address'),
          ),
        ],
      );
    },
  );
}

  double _calculateTotalPrice() {
    return widget.cartItems.fold(
      0.0,
      (sum, cartItem) =>
          sum + (cartItem.product.productPrice * cartItem.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Progress'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_userAddresses.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Delivery Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _userAddresses.length,
                    itemBuilder: (context, index) {
                      final address = _userAddresses[index];
                      return ListTile(
                        title: Text(address.userAddress),
                        leading: Radio<UserSignUpModels>(
                          value: address,
                          groupValue: _selectedAddress,
                          onChanged: (UserSignUpModels? value) {
                            setState(() {
                              _selectedAddress = value;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: _showAddAddressDialog,
                    child: const Text(
                      'Add New Address',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cartItems[index];
                final product = cartItem.product;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: kIsWeb ? Image.network(product.productImages.first,fit: BoxFit.cover,height: 80,width: 80,)
                          : Image.file(File(product.productImages.first),fit: BoxFit.cover, height: 80, width: 80,)
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '\$${product.productPrice}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Quantity: ${cartItem.quantity}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _selectedAddress != null
                      ? () async {
                          await addOrders(_selectedAddress!, widget.cartItems);
                          showSnackBar(context, 'Order placed successfully', Colors.green);
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
