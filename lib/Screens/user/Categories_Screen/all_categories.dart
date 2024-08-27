import 'package:fashion/Screens/user/Widgets/widget_home_screen.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';

class ScreenAllCategories extends StatefulWidget {
  final Function(String)? filterProducts;
  const ScreenAllCategories({super.key, required this.filterProducts,});

  @override
  State<ScreenAllCategories> createState() => _ScreenAllCategoriesState();
}


class _ScreenAllCategoriesState extends State<ScreenAllCategories> {
  
  late Future<List<CategoryModel>> _categoryFuture;

  @override
  void initState() {
    _categoryFuture = fetchAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final categories = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(title: const Text('Categories')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.separated(
                itemBuilder: (ctx, index) {
                  final category = categories[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      onTap: () async {
                        final filteredProducts = widget.filterProducts!(category.categoryName);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryScreen(
                              categoryName: category.categoryName,
                              products: filteredProducts,
                            ),
                          ),
                        );
                      },
                      title: Text(category.categoryName),
                      leading: CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 25,
                        child: category.categoryImage.isNotEmpty
                            ? ClipOval(
                                child: Image.memory(
                                  category.categoryImage,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.category, size: 60),
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const Divider();
                },
                itemCount: categories.length,
              ),
            ),
          ),
        );
      },
    );
  }
}
