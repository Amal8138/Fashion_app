import 'package:fashion/Screens/user/pages/filter_product_screen.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ScreenFilterProductScreen extends StatefulWidget {
  const ScreenFilterProductScreen({super.key});

  @override
  State<ScreenFilterProductScreen> createState() =>
      _ScreenFilterProductScreenState();
}

class _ScreenFilterProductScreenState extends State<ScreenFilterProductScreen> {
  RangeValues _priceRange = const RangeValues(100, 500);
  final double _minPrice = 100;
  final double _maxPrice = 10000;
  String? _selectedCategory;

  List<CategoryModel> _categories = [];
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchProducts(); 
  }

  Future<void> _fetchCategories() async {
    final box = await Hive.openBox<CategoryModel>('categoryBox');
    setState(() {
      _categories = box.values.toList();
    });
  }

  Future<void> _fetchProducts() async {
    final box = await Hive.openBox<ProductModel>('products');
    setState(() {
      _products = box.values.toList();
    });
  }

  void _applyFilters() {
    List<ProductModel> filteredProducts = _products.where((product) {
      return product.productCategory == _selectedCategory &&
          product.productPrice >= _priceRange.start &&
          product.productPrice <= _priceRange.end;
    }).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenFilterProductResultScreen(
          filteredProducts: filteredProducts,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Filter As Per Your Need',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                hint: const Text('Select Category'),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category.categoryName,
                    child: Text(category.categoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                  'Price Range: \$${_priceRange.start.toStringAsFixed(0)} - \$${_priceRange.end.toStringAsFixed(0)}'),
              RangeSlider(
                values: _priceRange,
                min: _minPrice,
                max: _maxPrice,
                divisions: (_maxPrice - _minPrice).toInt(),
                labels: RangeLabels(
                  _priceRange.start.toStringAsFixed(0),
                  _priceRange.end.toStringAsFixed(0),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white),
                    onPressed: (){
                      if(_selectedCategory == null){
                        showSnackBar(context, 'Select category', Colors.red);
                      }
                      else{
                        _applyFilters();
                      }
                    },
                    child: const Text('Apply')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
