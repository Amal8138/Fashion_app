import 'dart:io';

import 'package:fashion/db/models/db_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';


//Add user function
Future<void> saveUSerDetails(String id , String name , String address , String gender , String mobile , Uint8List img , String houseName , String houseNum , String locality) async {
  var userBox = await Hive.openBox<UserSignUpModels>('userBox');
  UserSignUpModels user = UserSignUpModels(
    userId: id, 
    userName: name, 
    userPhone: mobile, 
    userAddress: address, 
    userGender: gender, 
    userImage: img,
    houseName: houseName,
    houseNumber: houseNum,
    locality: locality
    );
    await userBox.put(id, user);
}

//code for getting own user details
 Future<UserSignUpModels?> fetchUserDetails() async {
    try {
      var box = await Hive.openBox<UserSignUpModels>('userBox');
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return null;
      return box.get(userId);
    } catch (e) {
      debugPrint('Error fetching details $e');
      return null;
    }
  }



//get all user details
Future<List<UserSignUpModels>> fetchAllUserDetails() async {
  var box = await Hive.openBox<UserSignUpModels>('userBox');
  return box.values.toList();
}



//get id for product
Future<int> _getNextProductId() async {
  var counterBox = Hive.box<int>('productIdCounter');
  int currentId = counterBox.get('currentId', defaultValue: 0) ?? 0;
  counterBox.put('currentId', currentId + 1);
  return currentId;
}


//adding product
Future<void> addProduct(ProductModel product) async {
  final productId = await _getNextProductId();
  final productBox = Hive.box<ProductModel>('products');

  final newProduct = ProductModel(
    productType: product.productType,
    productId: productId,
    productName: product.productName,
    productPrice: product.productPrice,
    productDetails: product.productDetails,
    productCategory: product.productCategory,
    productImages: product.productImages,
    productSize: product.productSize,
  );

  await productBox.put(productId, newProduct);
}


// default products
Future<void> initalizeDefaultProducts() async {
  print('Initializing default products...');
  final productBox = await Hive.openBox<ProductModel>('products');

  if (productBox.isEmpty) {
    final file1 = await copyAssetToFile("assets/images/img-1.jpg");
    final file2 = await copyAssetToFile("assets/images/img-2.jpg");
    final defaultProduct1 = ProductModel(
      productType: 'Type 1', 
      productId: 1, 
      productName: 'Sample 1', 
      productPrice: 799, 
      productDetails: 'Sample product 1', 
      productCategory: 'sample 1', 
      productImages: [file1.path], 
      productSize: ['S','M','L']
    );

    final defaultProduct2 = ProductModel(
      productType: 'Type 2', 
      productId: 2, 
      productName: 'Sample 2', 
      productPrice: 899, 
      productDetails: 'Sample product 2', 
      productCategory: 'sample 2', 
      productImages: [file2.path], 
      productSize: ['S','M','L','XL']
    );
    debugPrint('path ${file1.path}');

    await productBox.put(defaultProduct1.productId, defaultProduct1);
    await productBox.put(defaultProduct2.productId, defaultProduct2);
  }
}

Future<File> copyAssetToFile(String assetPath) async {
  try {
    print('Attempting to copy asset: $assetPath');
    
    final byteData = await rootBundle.load(assetPath);
    final fileName = assetPath.split('/').last;
    final file = File('${(await getTemporaryDirectory()).path}/$fileName');
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    print('Copied asset to: ${file.path}');
    
    return file;
  } catch (e, s) {
    print('Error copying asset: $e');
    print('Stack trace: $s');
    rethrow;
  }
}




//get all products
Future<List<ProductModel>> fetchAllProducts() async {
    try {
      var productBox = await Hive.openBox<ProductModel>('products');
      return productBox.values.toList();
    } catch (e) {
      debugPrint('Error fetching products: $e');
      return [];
    }
  }


//update added product
Future<void> updateProducts(ProductModel updateProductModel) async {
  final productBox = await Hive.openBox('products');
  productBox.put(updateProductModel.productId, updateProductModel);
}


//delete added product
Future<void> deletProductsFromHive(int productId) async {
  final productBox = Hive.box<ProductModel>('products');
  await productBox.delete(productId);
}



//add new category
Future<void> addCategory(int id , String name , Uint8List image) async {
  var categoryBox = await Hive.openBox<CategoryModel>('categoryBox');

  final data = CategoryModel(
    categoryId: id, 
    categoryName: name, 
    categoryImage: image
    );

    await categoryBox.put(id, data);
}


//get all category
Future<List<CategoryModel>> fetchAllCategories () async {
  var categoryBox = await Hive.openBox<CategoryModel>('categoryBox');
  return categoryBox.values.toList();
}


//delete category
Future<void> deleteCategoryFromHive(int id) async {
  var categoryBox = await Hive.openBox<CategoryModel>('categoryBox');
  await categoryBox.delete(id);
}

//add Product Type
Future<void> addProductType(int id , String type) async{
  final productTypeBox = await Hive.openBox<ProductTypeModel>('productTypeBox');

  final data = ProductTypeModel(
    id: id, 
    productType: type
    );

    await productTypeBox.put(id, data);
}


//get all product type
Future<List<ProductTypeModel>> fetchAllProductType() async {
  final productTypeBox = await Hive.openBox<ProductTypeModel>('productTypeBox');

  return productTypeBox.values.toList();
}



//add product to wish list
Future<void> addProductToWishlist(ProductModel product) async {
  try{
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if(userId == null) return;

    final box = await Hive.openBox<WishlistProductModel>('wishlistBox');
    final wishlistItem = WishlistProductModel(
      userId: userId, product: product
      );
      await box.add(wishlistItem);
      final favoritesBox = await Hive.openBox<bool>('favoritesBox');
      favoritesBox.put(product.productId, true);
  }
  catch (e) {
    debugPrint('$e');
  }
}


// remove product from wishlish
Future<void> removeFromWishlist(ProductModel product) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final box = await Hive.openBox<WishlistProductModel>('wishlistBox');

    final key = box.keys.firstWhere(
      (key) {
        final item = box.get(key) as WishlistProductModel;
        return item.userId == userId && item.product.productId == product.productId;
      },
      orElse: () => null,
    );

    if (key != null) {
      await box.delete(key);
      debugPrint('Product removed from wishlist');
      final favoritesBox = await Hive.openBox<bool>('favoritesBox');
      favoritesBox.put(product.productId, false);
    } else {
      debugPrint('Product not found in wishlist');
    }
  } catch (e) {
    debugPrint('Error removing from wishlist: $e');
  }
}


//get all product from wishlist
Future<List<WishlistProductModel>> fetchAllProductFromWishlist() async {
  try{
    final box = await Hive.openBox<WishlistProductModel>('wishlistBox');
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if(userId == null) return[];

    return box.values.where((item) => item.userId == userId).toList();
  }
  catch (e) {
    debugPrint('Error fetching wishlist$e');
    return [];
  }
}


//add product to cart
Future<void> addProductToCart(ProductModel product) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final box = await Hive.openBox<CartProductModel>('cartBox');

    final data = CartProductModel(
      userId: userId,
      product: product,
    );

    await box.add(data);

    debugPrint('Product added to cart: ${data.product.productName}');
  } catch (e) {
    debugPrint('Error adding product to cart: $e');
  }
}


//get all product from cart
Future<List<CartProductModel>> fetchAllProductsFromCart() async {
 try{
    final box = await Hive.openBox<CartProductModel>('cartBox');
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if(userId == null) return[];

    return box.values.where((item) => item.userId == userId).toList();
  }
  catch (e) {
    debugPrint('Error fetching wishlist$e');
    return [];
  }
}


//delete product from cart
Future<void> deleteProductFromCart(int productId) async {
  final cartBox = await Hive.openBox<CartProductModel>('cartBox');
  final keyToDelete = cartBox.keys.firstWhere((key) {
    final CartProductModel? product = cartBox.get(key);
    return product?.product.productId == productId;
  });
  await cartBox.delete(keyToDelete);
}


//clear cart
Future<void> clearAllProductsFromCart() async {
  var cartBox = await Hive.openBox<CartProductModel>('cartBox');
  await cartBox.clear();
}



//product quantity increasing from cart
Future<void> updateProductQuantityInCart(int productId, int newQuantity) async {
  try {
    final box = await Hive.openBox<CartProductModel>('cartBox');

    final cartProduct = box.values.firstWhere(
      (item) => item.product.productId == productId,
      orElse: () => throw Exception("Product not found in cart"),
    );

    cartProduct.quantity = newQuantity;
    await box.putAt(box.values.toList().indexOf(cartProduct), cartProduct);
  } catch (e) {
    print('Error updating product quantity: $e');
  }
}


//Add order to order box
Future<void> addOrders(UserSignUpModels selectedUser, List<CartProductModel> cartItems) async {
 
  var orderBox = await Hive.openBox<OrderItemsModel>('orderBox');

  for (var cartItem in cartItems) {
    final order = OrderItemsModel(
      user: selectedUser,
      product: cartItem.product,
      dateTime: DateTime.now(),
      quantity: cartItem.quantity
    );

    await orderBox.add(order);
  }
}



//fetch indivudal user orders
Future<List<OrderItemsModel>> fetchAllOrders() async {
  try {
    var box = await Hive.openBox<OrderItemsModel>('orderBox');
    final userId = FirebaseAuth.instance.currentUser?.uid;

    print('User ID: $userId');  

    if (userId == null) return [];

    final orders = box.values.where((item) => item.user.userId == userId).toList();
    print('Orders: $orders');  

    return orders;
  } catch (e) {
    debugPrint('Error: $e');
    return [];
  }
}


Future<List<OrderItemsModel>> fetchAllOrdersDetails() async {
  var box = await Hive.openBox<OrderItemsModel>('orderBox');
  return box.values.toList();
}











