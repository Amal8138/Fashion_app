import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';

class ScreenProductDetails extends StatefulWidget {
  final List<String> images;
  final String productName;
  final double productPrice;
  final String productDetails;
  final List<String> productSize;
  final int productId;
  final String productCategory;
  final String productType;

  const ScreenProductDetails({
    super.key,
    required this.images,
    required this.productType,
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.productSize, 
    required this.productId, 
    required this.productCategory,
  });

  @override
  State<ScreenProductDetails> createState() => _ScreenProductDetailsState();
}

class _ScreenProductDetailsState extends State<ScreenProductDetails> {
  String? _selectedSize;
  late PageController _pageController;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final favoritesBox = await Hive.openBox<bool>('favoritesBox');
    final isFavorited = favoritesBox.get(widget.productId, defaultValue: false);
    setState(() {
      _isFavorited = isFavorited ?? false;
    });
  }

  void _toggleFavorite() async {
    final favoritesBox = await Hive.openBox<bool>('favoritesBox');
    final isFavorited = favoritesBox.get(widget.productId, defaultValue: false);
    final product = ProductModel(
      productType: widget.productType,
      productId: widget.productId,
      productName: widget.productName,
      productPrice: widget.productPrice,
      productDetails: widget.productDetails,
      productCategory: widget.productCategory,
      productImages: widget.images,
      productSize: widget.productSize,
    );

    if (isFavorited == true) {
      setState(() {
        _isFavorited = false;
      });
      favoritesBox.put(widget.productId, false);
      removeFromWishlist(product); 
    } else {
      setState(() {
        _isFavorited = true;
      });
      favoritesBox.put(widget.productId, true);
      addProductToWishlist(product);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      final imageUrl = widget.images[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: kIsWeb
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                )
                              : FadeInImage(
                                placeholder: const AssetImage('assets/images/loading.png'), 
                                image: FileImage(File(imageUrl))
                                )
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SmoothPageIndicator(
                    controller: _pageController,
                    count: widget.images.length,
                    effect: ExpandingDotsEffect(
                        dotWidth: 10,
                        dotHeight: 10,
                        activeDotColor: primaryColor,
                        dotColor: Colors.grey.shade400,
                        expansionFactor: 2,
                        spacing: 8)),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Product Detail',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _isFavorited ? Colors.red : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.productDetails,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(height: 30, thickness: 1),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: DropdownButton<String>(
                      hint: const Text('Select Size'),
                      value: _selectedSize,
                      items: widget.productSize.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSize = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Price: ${widget.productPrice}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_selectedSize == null) {
                        showSnackBar(context, 'Select Size', Colors.red);
                      } else {
                        final product = ProductModel(
                          productType: widget.productType,
                          productId: widget.productId,
                          productName: widget.productName,
                          productPrice: widget.productPrice,
                          productDetails: widget.productDetails,
                          productCategory: widget.productCategory,
                          productImages: widget.images,
                          productSize: widget.productSize,
                        );
                        addProductToCart(product);
                        showSnackBar(context, 'Product added to cart successfully', Colors.green);
                      }
                    },
                    child: const Text(
                      'Add To Cart',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
