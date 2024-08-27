import 'dart:io';
import 'package:fashion/Screens/user/pages/order_progress.dart';
import 'package:fashion/Screens/user/pages/product_details.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ScreenCart extends StatefulWidget {
  const ScreenCart({super.key});

  @override
  State<ScreenCart> createState() => _ScreenCartState();
}
class _ScreenCartState extends State<ScreenCart> {
  late Future<List<CartProductModel>> _futureCartProducts;
  @override
  void initState() {
    _futureCartProducts = fetchAllProductsFromCart();
    super.initState();
  }
  Future<void> _refreshCart() async {
    setState(() {
      _futureCartProducts = fetchAllProductsFromCart();
    });
  }
  Future<void> _clearCart() async {
    await clearAllProductsFromCart(); 
    _refreshCart();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<CartProductModel>>(
        future: _futureCartProducts,
        builder: (context, AsyncSnapshot<List<CartProductModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Items in cart'),
            );
          }
          final cartItem = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product = cartItem[index].product;
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
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                                child: kIsWeb ? Image.network(product.productImages.first,fit: BoxFit.cover,)
                                                : FadeInImage(
                                                  placeholder: AssetImage('assets/images/loading.png'), 
                                                  image: FileImage(File(product.productImages.first))
                                                  )
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '\$${product.productPrice}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: primaryColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (ctx) {
                                                          return AlertDialog(
                                                            title:
                                                                const Text('Delete'),
                                                            content: const Text(
                                                                'Are you sure you want to delete this product?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text('No'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () async {
                                                                  await deleteProductFromCart(
                                                                      product
                                                                          .productId);
                                                                  Navigator.pop(
                                                                      context);
                                                                  _refreshCart();
                                                                },
                                                                child:
                                                                    const Text('Yes'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(Icons.delete,
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      if (cartItem[index].quantity > 1) {
                                                        setState(() {
                                                          cartItem[index].quantity--;
                                                        });
                                                        await updateProductQuantityInCart(
                                                            product.productId,
                                                            cartItem[index]
                                                                .quantity);
                                                      }
                                                    },
                                                    icon: const Icon(Icons.remove,
                                                        color: Colors.red),
                                                  ),
                                                  Text(
                                                    '${cartItem[index].quantity}',
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        cartItem[index].quantity++;
                                                      });
                                                      await updateProductQuantityInCart(
                                                          product.productId,
                                                          cartItem[index].quantity);
                                                    },
                                                    icon: const Icon(Icons.add,
                                                        color: Colors.green),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount: cartItem.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15.0,
                              mainAxisSpacing: 15.0,
                              childAspectRatio: 0.51,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ScreenOrderProgress(cartItems: cartItem),
                    ));
                    await _clearCart();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text(
                    'Order Now',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
