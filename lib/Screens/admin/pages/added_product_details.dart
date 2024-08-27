import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fashion/Screens/admin/pages/update_product.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';

class ScreenAddedProductsDetailPage extends StatefulWidget {
  final int productId;
  final String name;
  final String details;
  final double price;
  final List<String> size;
  final List<String> images;
  final String category;
  final String productType;

  const ScreenAddedProductsDetailPage({
    super.key,
    required this.productType,
    required this.name,
    required this.details,
    required this.price,
    required this.size,
    required this.images,
    required this.productId,
    required this.category,
  });

  @override
  State<ScreenAddedProductsDetailPage> createState() => _ScreenAddedProductsDetailPageState();
}

class _ScreenAddedProductsDetailPageState extends State<ScreenAddedProductsDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Product Detail',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 350,
                  child: PageView.builder(
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      final imageUrlOrPath = widget.images[index];
                      Widget imageWidget;

                      if (kIsWeb) {
                        if (imageUrlOrPath.startsWith('http')) {
                          imageWidget = Image.network(
                            imageUrlOrPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading network image: $error');
                              return const Icon(Icons.error);
                            },
                          );
                        } else if (imageUrlOrPath.startsWith('data:image')) {
                          // Extract Base64 part from the data URL
                          final base64String = imageUrlOrPath.split(',').last;
                          try {
                            final imageBytes = base64Decode(base64String);
                            imageWidget = Image.memory(
                              imageBytes,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error decoding Base64 image: $error');
                                return const Icon(Icons.error);
                              },
                            );
                          } catch (e) {
                            print('Error decoding Base64 image: $e');
                            imageWidget = const Icon(Icons.error);
                          }
                        } else {
                          imageWidget = const Icon(Icons.error);
                        }
                      } else {
                        if (imageUrlOrPath.startsWith('/data/')) {
                          imageWidget = Image.file(
                            File(imageUrlOrPath),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading file image: $error');
                              return const Icon(Icons.error);
                            },
                          );
                        } else if (imageUrlOrPath.startsWith('data:image')) {
                          final base64String = imageUrlOrPath.split(',').last;
                          try {
                            final imageBytes = base64Decode(base64String);
                            imageWidget = Image.memory(
                              imageBytes,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error decoding Base64 image: $error');
                                return const Icon(Icons.error);
                              },
                            );
                          } catch (e) {
                            print('Error decoding Base64 image: $e');
                            imageWidget = const Icon(Icons.error);
                          }
                        } else {
                          imageWidget = const Icon(Icons.error);
                        }
                      }

                      return imageWidget;
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Category : ${widget.category}'),
                Text('Type : ${widget.productType}'),
                const SizedBox(height: 10,),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Product Detail',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.details,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                Text(
                  'Price: ${widget.price} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final product = ProductModel(
                        productType: widget.productType,
                        productId: widget.productId, 
                        productName: widget.name, 
                        productPrice: widget.price, 
                        productDetails: widget.details, 
                        productCategory: widget.category, 
                        productImages: widget.images, 
                        productSize: widget.size
                        );
                      showGeneralDialog(
                        context: context, 
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Center(
                            child: Material(
                              type: MaterialType.transparency,
                              child: ScreenProductUpdate(data: product),
                            ),
                          );
                        },
                        );
                    },
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('Delete'),
                            content: const Text('Are you sure you want to delete this product?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteProduct();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteProduct() async {
    await deletProductsFromHive(widget.productId);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
