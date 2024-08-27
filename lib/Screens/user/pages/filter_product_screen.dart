import 'dart:io';

import 'package:fashion/Screens/user/pages/product_details.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ScreenFilterProductResultScreen extends StatelessWidget {
  final List<ProductModel> filteredProducts;

  const ScreenFilterProductResultScreen({Key? key, required this.filteredProducts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filtered Products"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: ScreenProductDetails(
                            productType: product.productType,
                            productCategory: product.productCategory,
                            productId: product.productId,
                            images: product.productImages,
                            productName: product.productName,
                            productPrice: product.productPrice,
                            productDetails: product.productDetails,
                            productSize: product.productSize,
                          ),
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 400),
                          alignment: Alignment.center,
                          curve: Curves.easeInOut,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 217, 217, 217),
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  child: kIsWeb ? Image.network(product.productImages.first,fit: BoxFit.cover,)
                                  :
                                  FadeInImage(
                                    placeholder: const AssetImage('assets/images/loading.png'),
                                    image: FileImage(File(product.productImages.first)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.productPrice}',
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
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
                childCount: filteredProducts.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 0.65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
