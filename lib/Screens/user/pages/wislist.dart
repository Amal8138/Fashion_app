import 'dart:io';
import 'package:fashion/Screens/user/pages/product_details.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class ScreenWishList extends StatefulWidget {
  const ScreenWishList({super.key});

  @override
  _ScreenWishListState createState() => _ScreenWishListState();
}

class _ScreenWishListState extends State<ScreenWishList> {
  late Future<List<WishlistProductModel>> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _wishlistFuture = fetchAllProductFromWishlist();
  }

  Future<void> _removeFromWishlist(WishlistProductModel product) async {
    setState(() {
      _wishlistFuture = Future.value(
        (_wishlistFuture as Future<List<WishlistProductModel>>).then((wishlistItems) {
          wishlistItems.removeWhere((item) => item.product.productId == product.product.productId);
          return wishlistItems;
        }),
      );
    });
    await removeFromWishlist(product.product);

    _wishlistFuture = fetchAllProductFromWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text(
            'Wishlist',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        Expanded(
          child: FutureBuilder<List<WishlistProductModel>>(
            future: _wishlistFuture,
            builder: (context, AsyncSnapshot<List<WishlistProductModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Items In Wishlist'));
              }

              final wishlistItems = snapshot.data!;

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = wishlistItems[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ScreenProductDetails(
                                        productType: product.product.productType,
                                        productCategory: product.product.productCategory,
                                        productId: product.product.productId,
                                        images: product.product.productImages,
                                        productName: product.product.productName,
                                        productPrice: product.product.productPrice,
                                        productDetails: product.product.productDetails,
                                        productSize: product.product.productSize,
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
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 10,
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
                                                top: Radius.circular(20),
                                              ),
                                              child: kIsWeb ? 
                                              Image.network(
                                                product.product.productImages.first,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if(loadingProgress == null) return child;
                                                  return  Center(
                                                    child: Image.asset('assets/images/loading.png')
                                                  );
                                                },
                                                ) 
                                              : FadeInImage(
                                                placeholder: const AssetImage('assets/images/loading.png'), 
                                                image: FileImage(File(product.product.productImages.first)),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                )
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                await _removeFromWishlist(product);
                                              },
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
                                              product.product.productName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\$${product.product.productPrice}',
                                              style: const TextStyle(
                                                fontSize: 14,
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
                            childCount: wishlistItems.length,
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15.0,
                            mainAxisSpacing: 15.0,
                            childAspectRatio: 0.68,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}