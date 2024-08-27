import 'package:fashion/Screens/admin/pages/create_category.dart';
import 'package:fashion/Screens/admin/pages/select_product_type.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';

class ScreenSelectingCategories extends StatefulWidget {
  const ScreenSelectingCategories({super.key});

  @override
  State<ScreenSelectingCategories> createState() => _ScreenSelectingCategoriesState();
}

class _ScreenSelectingCategoriesState extends State<ScreenSelectingCategories> {
  List<CategoryModel> _categories = [];

  CategoryModel? _selectedCategory;


  @override
  void initState() {
    fetchAllCategories().then((categories){
      setState(() {
        _categories = categories;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select Categories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
          ),
          const SizedBox(height: 20,),
          const Text('What type of product want to add',
          style: TextStyle(
            color: Colors.grey
          ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: const Text('Categories')
                ),
                items: _categories.map((CategoryModel category){
                  return DropdownMenuItem<CategoryModel>(
                    value: category,
                    child: Text(category.categoryName)
                    );
                }).toList(),
                onChanged: (CategoryModel? newValue){
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                ),
          ),
          SizedBox(
            width: 280,
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white
            ),
            onPressed: (){
              gotoNext();
            }, 
            child:const Text('Next')
            ),
          ),
          const SizedBox(height: 15,),
          TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ScreenCreatingCategory()));
          }, child: const Text('Create new category'))
        ],
      ),
    );
  }

  Future<void> gotoNext()async {
    if(_selectedCategory == null){
      showSnackBar(context, 'Select category', Colors.red);
    }
    else{
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ScreenSelectingProductType(category: _selectedCategory!.categoryName)));
    }
  }
}
