import 'package:fashion/Screens/user/pages/animated_splash.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

const USER_KEY_VALUE = 'user';

void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  Hive.initFlutter();
  if(!Hive.isAdapterRegistered(UserSignUpModelsAdapter().typeId)){
    Hive.registerAdapter(UserSignUpModelsAdapter());
  }
  if(!Hive.isAdapterRegistered(ProductModelAdapter().typeId)){
    Hive.registerAdapter(ProductModelAdapter());
  }
  if(!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)){
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if(!Hive.isAdapterRegistered(WishlistProductModelAdapter().typeId)){
    Hive.registerAdapter(WishlistProductModelAdapter());
  }
  if(!Hive.isAdapterRegistered(CartProductModelAdapter().typeId)){
    Hive.registerAdapter(CartProductModelAdapter());
  }
  if(!Hive.isAdapterRegistered(ProductTypeModelAdapter().typeId)){
    Hive.registerAdapter(ProductTypeModelAdapter());
  }
  if(!Hive.isAdapterRegistered(OrderItemsModelAdapter().typeId)){
    Hive.registerAdapter(OrderItemsModelAdapter());
  }
  if(!Hive.isAdapterRegistered(OrderStatusAdapter().typeId)){
    Hive.registerAdapter(OrderStatusAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenAnimatedSplash(),
    );
  }
}