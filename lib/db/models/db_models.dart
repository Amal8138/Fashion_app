
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'db_models.g.dart';

@HiveType(typeId: 1)
class UserSignUpModels {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String userPhone;

  @HiveField(3)
  final String userAddress;

  @HiveField(4)
  final String userGender;

  @HiveField(5)
  final Uint8List userImage;

  @HiveField(6)
  final String houseNumber;

  @HiveField(7)
  final String houseName;

  @HiveField(8)
  final String locality;

  UserSignUpModels({
    required this.userId, 
    required this.userName, 
    required this.userPhone, 
    required this.userAddress, 
    required this.userGender, 
    required this.userImage,
    required this.houseNumber,
    required this.houseName,
    required this.locality
    });
}


@HiveType(typeId: 2)
class ProductModel {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final double productPrice;

  @HiveField(3)
  final String productDetails;

  @HiveField(4)
  final String productCategory;

  @HiveField(5)
  final List<String> productImages;

  @HiveField(6)
  final List<String> productSize;

  @HiveField(7)
  final String productType;

  ProductModel({
    required this.productType,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.productCategory,
    required this.productImages,
    required this.productSize,
  });
}


@HiveType(typeId: 3)
class CategoryModel{
  @HiveField(0)
  final int categoryId;

  @HiveField(1)
  final String categoryName;

  @HiveField(2)
  final Uint8List categoryImage;

  CategoryModel({
    required this.categoryId, 
    required this.categoryName, 
    required this.categoryImage
    });
}


@HiveType(typeId: 4)
class WishlistProductModel{
  @HiveField(0)
  final String userId;
  
  @HiveField(1)
  final ProductModel product;

  WishlistProductModel({
    required this.userId, 
    required this.product
    });

}


@HiveType(typeId: 5)
class CartProductModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final ProductModel product;

  @HiveField(2)
  int quantity;

  CartProductModel({
    required this.userId,
    required this.product,
    this.quantity = 1, 
  });
}



@HiveType(typeId: 6)
class ProductTypeModel{

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String productType;

  ProductTypeModel({
    required this.id, 
    required this.productType
    });
}






@HiveType(typeId: 7)
class OrderItemsModel{

  @HiveField(0)
  final UserSignUpModels user;

  @HiveField(1)
  final ProductModel product;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final OrderStatus status;

  @HiveField(4)
  final int quantity;

  OrderItemsModel({
    required this.user, 
    required this.product, 
    required this.dateTime,
    this.status = OrderStatus.confirmed,
    required this.quantity
    });


OrderItemsModel copyWith({
    UserSignUpModels? user,
    ProductModel? product,
    DateTime? dateTime,
    OrderStatus? status,
    int? quantity
  }) {
    return OrderItemsModel(
      user: user ?? this.user,
      product: product ?? this.product,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      quantity: quantity?? this.quantity
    );
  }
}


@HiveType(typeId: 8)
enum OrderStatus {

  @HiveField(0)
  confirmed,

  @HiveField(1)
  inTransit,

  @HiveField(2)
  delivered
}

