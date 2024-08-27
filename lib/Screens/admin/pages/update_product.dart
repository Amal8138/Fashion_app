import 'dart:io';
import 'package:fashion/Screens/admin/widgets/text_form_field.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ScreenProductUpdate extends StatefulWidget {
  final ProductModel data;
  const ScreenProductUpdate({super.key, required this.data});

  @override
  State<ScreenProductUpdate> createState() => _ScreenProductUpdateState();
}

class _ScreenProductUpdateState extends State<ScreenProductUpdate> {
  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> _selectedImages = [];
  List<File> _selectImages = [];
  List<String> _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.data.productName;
    detailsController.text = widget.data.productDetails;
    priceController.text = widget.data.productPrice.toStringAsFixed(2);
    _selectedImages = widget.data.productImages;
    _selectedCategory = widget.data.productCategory;
    _loadAllCategory();
  }

  Future<void> _loadAllCategory() async {
  final categoryBox = Hive.box<CategoryModel>('categoryBox');
  final categories = categoryBox.values.map((category) => category.categoryName).toList();
  setState(() {
    _categories = categories;
    if (_selectedCategory != null && !_categories.contains(_selectedCategory)) {
      _selectedCategory = null; 
    }
  });
}

  @override
  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update'),
      content: Container(
        width: 300,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  selectMultipleImagesFromGallery();
                },
                child: _buildImageGrid(),
              ),
              const SizedBox(height: 15,),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DetailTextFormField(
                      controller: nameController, 
                      label: 'Product Name',
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                         return 'Name is required';
                      }
                         return null;
                      },
                      ),
                    const SizedBox(height: 15),
                    DetailTextFormField(
                      controller: detailsController, 
                      label: 'Product Details',
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                         return 'Details is required';
                      }
                         return null;
                      },
                      ),
                    const SizedBox(height: 15),
                     DetailTextFormField(
                      controller: priceController, 
                      label: 'Product Price',
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                         return 'Price is required';
                      }
                         return null;
                      },
                      ),
                    const SizedBox(height: 15,),
                    DropdownButtonFormField<String>(
                      value: _categories.isNotEmpty && _categories.contains(_selectedCategory)
                          ? _selectedCategory
                          : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text('Product Category'),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await updateProduct();
                        }
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    final allImages = [..._selectedImages, ..._selectImages.map((file) => file.path)];
    return allImages.isNotEmpty
      ? GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
          itemCount: allImages.length,
          itemBuilder: (context, index) {
            final image = allImages[index];
            return kIsWeb ? Image.network(image,fit: BoxFit.cover,) :  Image.file(File(image), fit: BoxFit.cover);
          })
      : CircleAvatar(
          radius: 40,
          backgroundColor: Colors.teal.shade100,
        );
  }

  Future<void> updateProduct() async {
    try {
      final productBox = Hive.box<ProductModel>('products');
      final imagePaths = [..._selectedImages, ..._selectImages.map((image) => image.path)];
      final updatedProduct = ProductModel(
        productType: widget.data.productType,
        productId: widget.data.productId,
        productName: nameController.text,
        productPrice: double.parse(priceController.text),
        productDetails: detailsController.text,
        productCategory: _selectedCategory ?? widget.data.productCategory,
        productImages: imagePaths,
        productSize: widget.data.productSize,
      );
      await productBox.put(widget.data.productId, updatedProduct);
      debugPrint('Product updated successfully');
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Failed to update product: $e');
    }
  }

  Future<void> selectMultipleImagesFromGallery() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectImages = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
          _selectedImages.clear();
        });
      }
    } catch (e) {
      debugPrint('Error to select image: $e');
    }
  }
}
