import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';

class ScreenAdminAllCategories extends StatefulWidget {
  const ScreenAdminAllCategories({super.key});

  @override
  State<ScreenAdminAllCategories> createState() => _ScreenAdminAllCategoriesState();
}

class _ScreenAdminAllCategoriesState extends State<ScreenAdminAllCategories> {

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
      builder: (context , snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else if(snapshot.hasError){
          return Center(
            child: Text('Error ${snapshot.error}'),
          );
        }
        final category = snapshot.data!;

        return Scaffold(
          body: SafeArea(
          child:Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.separated(
              itemBuilder: (ctx , index){
                final categorys = category[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListTile(
                    onTap: () {
                     
                    },
                    title: Text(categorys.categoryName),
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 25,
                      child: categorys.categoryImage.isNotEmpty ? ClipOval(
                        child: Image.memory(
                          width: 50,
                          height: 50,
                          categorys.categoryImage,
                          fit: BoxFit.cover,
                          ),
                      ) : const Icon(Icons.person , size: 60,),
                    ),
                    trailing: IconButton(onPressed: (){
                      showDialog(context: context, builder: (ctx) {
                        return AlertDialog(
                        title: const Text('Are you sure to delete'),
                        content: const Text('All items will removed under this category'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: const Text('No')),
                          TextButton(onPressed: (){
                            deleteCategoryFromHive(categorys.categoryId);
                            Navigator.pop(context);
                          }, child: const Text('Yes'))
                        ],
                      );
                      });
                    }, icon: const Icon(Icons.delete),color: Colors.red,),
                  ),
                );
              }, 
              separatorBuilder: (ctx , index){
                return const Divider();
              }, 
              itemCount: category.length
              ),
          )
          ),
        );

      }
      );
  }
}