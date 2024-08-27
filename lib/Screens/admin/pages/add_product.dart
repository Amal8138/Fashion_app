import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fashion/Screens/admin/widgets/bottom_navigation.dart';
import 'package:fashion/Screens/admin/widgets/text_form_field.dart';
import 'package:fashion/Screens/user/Widgets/text_field.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/db/models/db_models.dart';
import 'dart:convert';


class ScreenAddProducts extends StatefulWidget {
  final String category;
  final String productType;
  const ScreenAddProducts({super.key, required this.category, required this.productType});

  @override
  State<ScreenAddProducts> createState() => _ScreenAddProductsState();
}

class _ScreenAddProductsState extends State<ScreenAddProducts> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productDetails = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  List<File> _fileImages = [];
  List<Uint8List> _webImages = [];
  final Map<String, bool> _sizes = {
    'S': false,
    'M': false,
    'L': false,
    'XL': false,
    'XXL': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add Product',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: pickProductImagesFromGallery,
                  child: _buildImageGrid(),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DetailTextFormField(
                        controller: _productName, 
                        label: 'Product Name',
                        validator: (p0) {
                          if(p0 == null || p0.isEmpty){
                            return 'Product Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      DetailTextFormField(
                        controller: _productDetails, 
                        label: 'Product Details',
                        validator: (p0) {
                          if(p0 == null || p0.isEmpty){
                            return 'Product Details is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _productPrice,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          label: const Text('Product Price'),
                        ),
                      ),
                      const SizedBox(height: 15),
                      buildProfileField('Categories', widget.category),
                      const SizedBox(height: 15),
                      const Text(
                        'Select size',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      _buildSizeCheckboxes(),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              addProductsToDb();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (ctx) => const ScreenAdminBottomNavigation(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            }
                          },
                          child: const Text('Add Product'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _sizes.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          value: _sizes[key],
          onChanged: (bool? value) {
            setState(() {
              _sizes[key] = value!;
            });
          },
        );
      }).toList(),
    );
  }

 Future<void> pickProductImagesFromGallery() async {
  try {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      if (kIsWeb) {
        List<Uint8List> imageBytes = await Future.wait(
          pickedFiles.map((pickedFile) async {
            final bytes = await pickedFile.readAsBytes();
            return bytes;
          }),
        );
        setState(() {
          _webImages = imageBytes;
        });
      } else {
        setState(() {
          _fileImages = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
        });
      }
    }
  } catch (e) {
    debugPrint('$e');
  }
}


 Widget _buildImageGrid() {
  final imageCount = kIsWeb ? _webImages.length : _fileImages.length;
  return imageCount > 0
      ? GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: imageCount,
          itemBuilder: (context, index) {
            if (kIsWeb) {
              return Image.memory(
                _webImages[index],
                fit: BoxFit.cover,
              );
            } else {
              return Image.file(
                _fileImages[index],
                fit: BoxFit.cover,
              );
            }
          },
        )
      : const Center(child: Text('No images selected'));
}




 Future<void> addProductsToDb() async {
  try {
    final name = _productName.text.trim();
    final details = _productDetails.text.trim();
    final price = double.tryParse(_productPrice.text.trim()) ?? 0.0;

    final imagePaths = kIsWeb
        ? await Future.wait(_webImages.map((image) async {
            
            return 'data:image/png;base64,' + base64Encode(image);
          }))
        : _fileImages.map((file) => file.path).toList();

    final selectedSizes = _sizes.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final productId = await _getNextProductId();

    final newProduct = ProductModel(
      productType: widget.productType,
      productId: productId,
      productName: name,
      productPrice: price,
      productDetails: details,
      productCategory: widget.category,
      productImages: imagePaths,
      productSize: selectedSizes,
    );

    await _addProduct(newProduct);
    showSnackBar(context, 'Product added successfully', Colors.green);
  } catch (e) {
    debugPrint('Error: $e');
  }
}



  Future<int> _getNextProductId() async {
    var counterBox = await Hive.openBox<int>('productIdCounter');
    int currentId = counterBox.get('currentId', defaultValue: 0) ?? 0;
    await counterBox.put('currentId', currentId + 1);
    return currentId;
  }

  Future<void> _addProduct(ProductModel product) async {
    var productBox = await Hive.openBox<ProductModel>('products');
    await productBox.put(product.productId, product);
  }
}
