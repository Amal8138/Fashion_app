// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSignUpModelsAdapter extends TypeAdapter<UserSignUpModels> {
  @override
  final int typeId = 1;

  @override
  UserSignUpModels read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSignUpModels(
      userId: fields[0] as String,
      userName: fields[1] as String,
      userPhone: fields[2] as String,
      userAddress: fields[3] as String,
      userGender: fields[4] as String,
      userImage: fields[5] as Uint8List,
      houseNumber: fields[6] as String? ?? "Unknown",
      houseName: fields[7] as String? ?? "Unknown",
      locality: fields[8] as String? ?? "Unknown",
    );
  }

  @override
  void write(BinaryWriter writer, UserSignUpModels obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userPhone)
      ..writeByte(3)
      ..write(obj.userAddress)
      ..writeByte(4)
      ..write(obj.userGender)
      ..writeByte(5)
      ..write(obj.userImage)
      ..writeByte(6)
      ..write(obj.houseNumber)
      ..writeByte(7)
      ..write(obj.houseName)
      ..writeByte(8)
      ..write(obj.locality);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSignUpModelsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      productType: fields[7] as String,
      productId: fields[0] as int,
      productName: fields[1] as String,
      productPrice: fields[2] as double,
      productDetails: fields[3] as String,
      productCategory: fields[4] as String,
      productImages: (fields[5] as List).cast<String>(),
      productSize: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.productPrice)
      ..writeByte(3)
      ..write(obj.productDetails)
      ..writeByte(4)
      ..write(obj.productCategory)
      ..writeByte(5)
      ..write(obj.productImages)
      ..writeByte(6)
      ..write(obj.productSize)
      ..writeByte(7)
      ..write(obj.productType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 3;

  @override
  CategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryModel(
      categoryId: fields[0] as int,
      categoryName: fields[1] as String,
      categoryImage: fields[2] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.categoryId)
      ..writeByte(1)
      ..write(obj.categoryName)
      ..writeByte(2)
      ..write(obj.categoryImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WishlistProductModelAdapter extends TypeAdapter<WishlistProductModel> {
  @override
  final int typeId = 4;

  @override
  WishlistProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistProductModel(
      userId: fields[0] as String,
      product: fields[1] as ProductModel,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistProductModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.product);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CartProductModelAdapter extends TypeAdapter<CartProductModel> {
  @override
  final int typeId = 5;

  @override
  CartProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartProductModel(
      userId: fields[0] as String,
      product: fields[1] as ProductModel,
      quantity: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartProductModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.product)
      ..writeByte(2)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductTypeModelAdapter extends TypeAdapter<ProductTypeModel> {
  @override
  final int typeId = 6;

  @override
  ProductTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductTypeModel(
      id: fields[0] as int,
      productType: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderItemsModelAdapter extends TypeAdapter<OrderItemsModel> {
  @override
  final int typeId = 7;

  @override
  OrderItemsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItemsModel(
      user: fields[0] as UserSignUpModels,
      product: fields[1] as ProductModel,
      dateTime: fields[2] as DateTime,
      status: fields[3] as OrderStatus,
      quantity: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItemsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.product)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderStatusAdapter extends TypeAdapter<OrderStatus> {
  @override
  final int typeId = 8;

  @override
  OrderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderStatus.confirmed;
      case 1:
        return OrderStatus.inTransit;
      case 2:
        return OrderStatus.delivered;
      default:
        return OrderStatus.confirmed;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatus obj) {
    switch (obj) {
      case OrderStatus.confirmed:
        writer.writeByte(0);
        break;
      case OrderStatus.inTransit:
        writer.writeByte(1);
        break;
      case OrderStatus.delivered:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
