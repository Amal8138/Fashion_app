import 'package:fashion/Screens/user/Widgets/widget_home_screen.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late List<bool> _isFavorited = [];

  final List<String> _carouselImgList = [
    "assets/images/img-1.jpg",
    "assets/images/img-2.jpg",
    "assets/images/img-3.jpg",
    "assets/images/img-5.jpg",
  ];

  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _initializeAndFetchProducts();
  }

  void _toggleFavorite(int index) async {
    setState(() {
      _isFavorited[index] = !_isFavorited[index];
    });
    final product = _products[index];
    if (_isFavorited[index]) {
      addProductToWishlist(product);
    } else {
      removeFromWishlist(product);
    }
    final favoritesBox = await Hive.openBox<bool>('favoritesBox');
    favoritesBox.put(product.productId, _isFavorited[index]);
  }

  Future<void> _initializeAndFetchProducts() async {
    try{
      await initalizeDefaultProducts();
      await _fetchProducts();
    }
    catch(e) {
      debugPrint('Error$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSignUpModels?>(
      future: fetchUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No User available'),
          );
        }
        final user = snapshot.data!;

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        HeaderSection(user: user),
                        const SizedBox(height: 10),
                        const SearchAndFilter(),
                        CarouselSliderWidget(
                          images: _carouselImgList,
                          placeholder: 'assets/images/loading.png',
                          ),
                        CategoriesSection(
                          filterProducts: _filterProducts,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: _products.isNotEmpty && _isFavorited.isNotEmpty
                      ? ProductGrid(
                          products: _products,
                          isFavorited: _isFavorited,
                          toggleFavorite: _toggleFavorite,
                        )
                      : const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchProducts() async {
    try {
      var productsBox = await Hive.openBox<ProductModel>('products');
      var favoritesBox = await Hive.openBox<bool>('favoritesBox');

      final productList = productsBox.values.toList();

      setState(() {
        _products = productList;
        _isFavorited = List<bool>.generate(
          _products.length,
          (index) {
            final productId = _products[index].productId;
            final isFavorited = favoritesBox.get(productId, defaultValue: false);
            if (isFavorited is bool) {
              return isFavorited;
            } else {
              debugPrint('Unexpected type for favorite status: $isFavorited');
              return false;
            }
          },
        );
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  List<ProductModel> _filterProducts(String category) {
    return _products.where((product) => product.productCategory == category).toList();
  }
}
