import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:flutter/material.dart';

class ScreenCreatingProductType extends StatelessWidget {
   ScreenCreatingProductType({super.key});
  final _typeName = TextEditingController();

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
              const Text('Create Product Type',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
              ),
              const SizedBox(height: 20,),
              Form(
                key: formKey,
                child: Column(
                children: [
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: _typeName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: const Text('Product Type ')
                    ),
                    validator: (value) {
                      if(value == null){
                        return 'Product type is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white
                      ),
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          _createProductType(context);
                        }
                      }, 
                      child: const Text('Create')
                      ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createProductType(BuildContext context) async {
    final id = DateTime.now().microsecondsSinceEpoch % 0xFFFFFFFF;
    final name = _typeName.text.trim();

    try{
      addProductType(id, name);

      //showSnackBar(context, 'Product type adding successfully', Colors.green);

      Navigator.pop(context);
    }
    catch(e){
      debugPrint('Error to add $e');
    }
  }
}