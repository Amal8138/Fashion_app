import 'package:fashion/Screens/admin/pages/user_detailed_page.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/functions/db_functions.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';

class ScreenAdminAllUsers extends StatefulWidget {
  const ScreenAdminAllUsers({super.key});

  @override
  State<ScreenAdminAllUsers> createState() => _ScreenAdminAllUsersState();
}

class _ScreenAdminAllUsersState extends State<ScreenAdminAllUsers> {
  late Future<List<UserSignUpModels>> _userFutures;

  @override
  void initState() {
    _userFutures = fetchAllUserDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userFutures, 
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
        else if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(
            child: Text('No Users Found'),
          );
        }

        final users = snapshot.data!;

        return SafeArea(
          child:Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.separated(
              itemBuilder: (ctx , index){
                final user = users[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => UserDetailedPage(
                          userName: user.userName, 
                          userAddress: user.userAddress, 
                          userPhone: user.userPhone, 
                          userGender: user.userGender, 
                          userId: user.userId, 
                          userImage: user.userImage,
                          userHouseName: user.houseName,
                          userHouseNum: user.houseNumber,
                          locality: user.locality,
                          )));
                    },
                    title: Text(user.userName),
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 25,
                      child: user.userImage.isNotEmpty ? ClipOval(
                        child: Image.memory(
                          width: 50,
                          height: 50,
                          user.userImage,
                          fit: BoxFit.cover,
                          ),
                      ) : const Icon(Icons.person , size: 60,),
                    ),
                  ),
                );
              }, 
              separatorBuilder: (ctx , index){
                return const Divider();
              }, 
              itemCount: users.length
              ),
          )
          );
      }
      );
  }
}