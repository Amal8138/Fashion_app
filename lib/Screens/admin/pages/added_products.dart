import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fashion/Screens/admin/pages/added_product_details.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';

class ScreenAdminAllAddedProducts extends StatefulWidget {
  const ScreenAdminAllAddedProducts({super.key});

  @override
  _ScreenAdminAllAddedProductsState createState() =>
      _ScreenAdminAllAddedProductsState();
}

class _ScreenAdminAllAddedProductsState
    extends State<ScreenAdminAllAddedProducts> {
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchAllProducts();
  }

  void _refreshProducts() {
    setState(() {
      _futureProducts = fetchAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No added products'),
          );
        }

        final products = snapshot.data!;

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      final imageUrlOrPath = product.productImages.isNotEmpty
                          ? product.productImages.first
                          : '';
                      Widget imageWidget;

                      if (imageUrlOrPath == 'WebImage') {
                        imageWidget = Image.asset(
                          'assets/images/loading.png',
                          fit: BoxFit.cover,
                        );
                      } else if (imageUrlOrPath.startsWith('http')) {
                        imageWidget = Image.network(
                          imageUrlOrPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading network image: $error');
                            return const Icon(Icons.error);
                          },
                        );
                      } else if (imageUrlOrPath.startsWith('/data/')) {
                        imageWidget = Image.file(
                          File(imageUrlOrPath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading file image: $error');
                            return const Icon(Icons.error);
                          },
                        );
                      } else {
                        try {
                          final imageBytes = base64Decode(
                            imageUrlOrPath.contains('base64,')
                                ? imageUrlOrPath.split('base64,').last
                                : imageUrlOrPath,
                          );
                          imageWidget = Image.memory(
                            imageBytes,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error decoding Base64 image: $error');
                              return const Icon(Icons.error);
                            },
                          );
                        } catch (e) {
                          debugPrint('Error decoding Base64 image: $e');
                          imageWidget = const Icon(Icons.error);
                        }
                      }

                      return InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => ScreenAddedProductsDetailPage(
                                    productId: product.productId,
                                    productType: product.productType,
                                    name: product.productName,
                                    details: product.productDetails,
                                    price: product.productPrice,
                                    size: product.productSize,
                                    images: product.productImages,
                                    category: product.productCategory,
                                  )));
                          _refreshProducts();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.teal, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: imageWidget,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '\$${product.productPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
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
                    childCount: products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.70,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
