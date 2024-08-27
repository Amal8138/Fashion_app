import 'dart:io';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScreenCreatingCategory extends StatefulWidget {
  const ScreenCreatingCategory({super.key});

  @override
  State<ScreenCreatingCategory> createState() => _ScreenCreatingCategoryState();
}

class _ScreenCreatingCategoryState extends State<ScreenCreatingCategory> {
  final _categoryName = TextEditingController();
  File? _pickedImage;
  Uint8List? _selectImage;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    InkWell(
                      onTap: _pickImageFromGallery,
                      child: CircleAvatar(
                        radius: 40,
                        child: kIsWeb
                            ? (_selectImage != null
                                ? Image.memory(_selectImage!, width: 80, height: 80, fit: BoxFit.cover)
                                : const Icon(Icons.category_outlined))
                            : (_pickedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      _pickedImage!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.category_outlined)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _categoryName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text('Category Name'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Category name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _addCategoryToDb();
                          }
                        },
                        child: const Text('Create'),
                      ),
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

  Future<void> _pickImageFromGallery() async {
  try {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage != null) {
      debugPrint('Picked image path: ${returnImage.path}'); // Add this line
      setState(() {
        if (kIsWeb) {
          returnImage.readAsBytes().then((value) {
            setState(() {
              _selectImage = value;
            });
          }).catchError((error) {
            showSnackBar(context, 'Failed to pick image: $error', Colors.red);
          });
        } else {
          _pickedImage = File(returnImage.path);
        }
      });
    } else {
      showSnackBar(context, 'No image selected', Colors.red);
    }
  } catch (e) {
    showSnackBar(context, 'Failed to pick image: $e', Colors.red);
    debugPrint('Error picking image: $e');
  }
}


  Future<void> _addCategoryToDb() async {
  final id = DateTime.now().microsecondsSinceEpoch % 0xFFFFFFFF;
  final name = _categoryName.text.trim();

  try {
    // Debug information
    debugPrint('Category ID: $id');
    debugPrint('Category Name: $name');
    debugPrint('Image: ${kIsWeb ? (_selectImage != null ? "Present" : "Absent") : (_pickedImage != null ? "Present" : "Absent")}');

    if (kIsWeb && _selectImage == null) {
      showSnackBar(context, 'Image is required', Colors.red);
      return;
    }
    if (!kIsWeb && _pickedImage == null) {
      showSnackBar(context, 'Image is required', Colors.red);
      return;
    }

    Uint8List? imageBytes;

    if (kIsWeb) {
      imageBytes = _selectImage;
    } else if (_pickedImage != null) {
      imageBytes = await _pickedImage!.readAsBytes();
    }

    if (imageBytes != null) {
      addCategory(id, name, imageBytes);
    }

    showSnackBar(context, 'Category created successfully', Colors.green);
    Navigator.pop(context);
  } catch (e) {
    showSnackBar(context, 'An error occurred: $e', Colors.red);
    debugPrint('$e');
  }
}



}
