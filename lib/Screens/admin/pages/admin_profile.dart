import 'package:fashion/Screens/admin/pages/all_categories.dart';
import 'package:fashion/Screens/user/pages/animated_splash.dart';
import 'package:flutter/material.dart';

class ScreenAdminProfile extends StatelessWidget {
  const ScreenAdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text('Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
                )),
              const SizedBox(height: 15,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ScreenAdminAllCategories()));
                },
                child: const SizedBox(
                  width: double.infinity,
                  height:60,
                  child:  Padding(
                    padding:  EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Added Categories'),
                        Icon(Icons.arrow_right)
                      ],
                    ),
                  ),
                ),
              ),
               InkWell(
                onTap: () {
                  showDialog(context: context, builder: (ctx){
                    return AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure to log out'),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child:const Text('No')),
                        TextButton(onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (ctx) => const ScreenAnimatedSplash()), 
                            (Route<dynamic> route) => false);
                        }, child: const Text('Yes'))
                      ],

                    );
                  });
                },
                 child: const SizedBox(
                   width: double.infinity,
                   height: 100,
                   child:  Padding(
                     padding:  EdgeInsets.all(20),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('Log Out'),
                         Icon(Icons.logout)
                       ],
                     ),
                   ),
                 ),
               )
            ],
          ),
        ),
      ),
    );
  }
}