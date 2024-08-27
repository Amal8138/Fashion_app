import 'package:fashion/Screens/admin/pages/add_product.dart';
import 'package:fashion/Screens/admin/pages/create_product_type.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';

class ScreenSelectingProductType extends StatefulWidget {
  final String category;
  const ScreenSelectingProductType({super.key, required this.category});

  @override
  State<ScreenSelectingProductType> createState() => _ScreenSelectingProductTypeState();
}

class _ScreenSelectingProductTypeState extends State<ScreenSelectingProductType> {
  final typeController = TextEditingController();

  List<ProductTypeModel> _productTypes = [];
  ProductTypeModel? _selectedType;
  
  @override
  void initState() {
    fetchAllProductType().then((categories){
      setState(() {
        _productTypes = categories;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select Product Type',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
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
                  label: const Text('Product Type')
                ),
                items: _productTypes.map((ProductTypeModel category){
                  return DropdownMenuItem<ProductTypeModel>(
                    value: category,
                    child: Text(category.productType)
                    );
                }).toList(),
                onChanged: (ProductTypeModel? newValues){
                  setState(() {
                    _selectedType = newValues;
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
              if(_selectedType == null){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  content: Text('Select Product Type')));
                
              }
              else{
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ScreenAddProducts(
                category: widget.category, 
                productType: _selectedType!.productType
                )));
              }
            }, 
            child:const Text('Next')
            ),
          ),
          const SizedBox(height: 15,),
          TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>  ScreenCreatingProductType()));
          }, child: const Text('Create new type'))
        ],
      ),
    ),
    );
  }
}