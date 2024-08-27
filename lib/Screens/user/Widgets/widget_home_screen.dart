import 'dart:io';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fashion/Screens/user/Categories_Screen/all_categories.dart';
import 'package:fashion/Screens/user/Widgets/text_field.dart';
import 'package:fashion/Screens/user/pages/account.dart';
import 'package:fashion/Screens/user/pages/filter_screen.dart';
import 'package:fashion/Screens/user/pages/product_details.dart';
import 'package:fashion/Screens/user/pages/search_screen.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


// Reusable Widget for Header Section
class HeaderSection extends StatelessWidget {
  final UserSignUpModels user;

  const HeaderSection({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Hello',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                user.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const ScreenAccount()));
          },
          child: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 20,
            child: user.userImage.isNotEmpty
                ? ClipOval(
                    child: Image.memory(
                      user.userImage,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.person, size: 60, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

// Reusable Widget for Search and Filter
class SearchAndFilter extends StatelessWidget {
  const SearchAndFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const ScreenSearch()),
              );
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ScreenFilterProductScreen()));
          },
          icon: const Icon(
            Icons.filter_list_alt,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}

// Reusable Widget for Carousel Slider
class CarouselSliderWidget extends StatelessWidget {
  final List<String> images;
  final String placeholder;
  const CarouselSliderWidget({required this.images,required this.placeholder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final slider_controller.CarouselController controller = slider_controller.CarouselController();

    return CarouselSlider(
      items: images.map((item) {
        return Container(
          child: Center(
            child: FadeInImage(
              placeholder: AssetImage(placeholder), 
              image: AssetImage(item),
              fit: BoxFit.cover,
              width: double.infinity,
              )
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 210,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
      ),
      //carouselController: controller, 
    );
  }
}

// Reusable Widget for Categories Section

class CategoriesSection extends StatefulWidget {
  final Function(String) filterProducts;

  const CategoriesSection({required this.filterProducts, Key? key})
      : super(key: key);

  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  Box<CategoryModel>? categoriesBox;
  bool _isBoxOpen = false;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    categoriesBox = await Hive.openBox<CategoryModel>('categoryBox');
    if (mounted) {
      setState(() {
        _isBoxOpen = true;
      });
    }
  }

  @override
  void dispose() {
    if (_isBoxOpen) {
      categoriesBox?.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBoxOpen) {
      return const Center(child: CircularProgressIndicator());
    }

    final categories = categoriesBox!.values.toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) =>  ScreenAllCategories(filterProducts:widget.filterProducts ,)));
              },
              child: const Text('See All'),
            ),
          ],
        ),
        Container(
          height: 70,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CategoryCircle(
                    imagePath: category.categoryImage,
                    onTap: () {
                      final filteredProducts =
                          widget.filterProducts(category.categoryName);
                      Navigator.push(
                        context,
                        PageTransition(
                          child: CategoryScreen(
                            categoryName: category.categoryName,
                            products: filteredProducts,
                          ),
                          type: PageTransitionType.fade,
                          alignment: Alignment.center,
                          duration: const Duration(milliseconds: 600),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}


// Category category vise card section
class CategoryScreen extends StatelessWidget {
  final String categoryName;
  final List<ProductModel> products;

  const CategoryScreen(
      {required this.categoryName, required this.products, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
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
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  child: kIsWeb ? Image.network(product.productImages.first,fit: BoxFit.cover,)
                                  : Image.file(
                                    File(product.productImages.first),
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
                                productDetails(
                                    product.productName, Colors.black87),
                                const SizedBox(height: 4),
                                productDetails(
                                    '\$${product.productPrice}', primaryColor),
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
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 0.68,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Widget for Category Circle
class CategoryCircle extends StatelessWidget {
  final Uint8List imagePath;
  final VoidCallback onTap;

  const CategoryCircle({required this.imagePath, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: backgroundColors,
        radius: 30,
        child: Center(
            child: Image.memory(
          imagePath,
          height: 30,
          width: 30,
          fit: BoxFit.cover,
        )),
      ),
    );
  }
}

// Reusable Widget for Product Grid
class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final List<bool> isFavorited;
  final Function(int) toggleFavorite;

  const ProductGrid({
    required this.products,
    required this.isFavorited,
    required this.toggleFavorite,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            isFavorited: isFavorited[index],
            onFavoriteToggle: () => toggleFavorite(index),
          );
        },
        childCount: products.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio: 0.65,
      ),
    );
  }
}

// Reusable Widget for Product Card

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isFavorited;
  final VoidCallback onFavoriteToggle;

  const ProductCard({
    required this.product,
    required this.isFavorited,
    required this.onFavoriteToggle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: kIsWeb
                        ? Image.network(
                            product.productImages.isNotEmpty
                                ? product.productImages.first
                                : 'assets/images/placeholder.png',
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
                          image: FileImage(File(product.productImages.first)),
                          imageErrorBuilder: (context, error, stackTrace) {
                            print('error loading image $error');
                            return const Icon(Icons.error);
                          },
                          )
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 7,
                  child: IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.white,
                      size: 28,
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
  }
}
