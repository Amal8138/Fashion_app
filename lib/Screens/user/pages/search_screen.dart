import 'dart:io';
import 'package:fashion/Screens/user/pages/product_details.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  List<ProductModel> searchResult = [];
  List<ProductModel> allProducts = [];
  String query = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
  }

  Future<void> _fetchAllProducts() async {
    List<ProductModel> products = await fetchAllProducts();
    setState(() {
      allProducts = products;
      searchResult = products;
      isLoading = false;
    });
  }

  void _updateSearchResult(String query) {
    setState(() {
      this.query = query;
      if (query.isEmpty) {
        searchResult = allProducts;
      } else {
        searchResult = allProducts.where((product) {
          return product.productName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products',style: TextStyle(color: Colors.white),),
        backgroundColor: primaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                _updateSearchResult(value);
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : searchResult.isEmpty
              ? const Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.70,
                  ),
                  itemCount: searchResult.length,
                  itemBuilder: (context, index) {
                    final product = searchResult[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => ScreenProductDetails(
                              images: product.productImages,
                              productType: product.productType,
                              productName: product.productName,
                              productPrice: product.productPrice,
                              productDetails: product.productDetails,
                              productSize: product.productSize,
                              productId: product.productId,
                              productCategory: product.productCategory,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: Colors.deepPurple.withOpacity(0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: kIsWeb ? Image.network(product.productImages.first, fit: BoxFit.cover,height: 150,width: double.infinity,)
                              : Image.file(File(product.productImages.first) , fit: BoxFit.cover, height: 150,width: double.infinity,)
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '\$${product.productPrice}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
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
    );
  }
}
