import 'package:fashion/Screens/admin/widgets/text_form_decoration_profile.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserDetailedPage extends StatefulWidget {
  final String userName;
  final String userAddress;
  final String userPhone;
  final String userGender;
  final String userId;
  final Uint8List userImage;
  final String userHouseName;
  final String userHouseNum;
  final String locality;
  const UserDetailedPage({
    super.key, 
    required this.userName, 
    required this.userAddress, 
    required this.userPhone, 
    required this.userGender, 
    required this.userId, 
    required this.userImage,
    required this.userHouseName,
    required this.userHouseNum,
    required this.locality
    });

  @override
  State<UserDetailedPage> createState() => _UserDetailedPageState();
}

class _UserDetailedPageState extends State<UserDetailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                   padding: const EdgeInsets.all(4), 
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.teal.shade300, width: 3),
                ),
                  child: CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 60,
                    child: ClipOval(
                      child: Image.memory(widget.userImage,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      ),
                    )
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              buildProfileField('User id', widget.userId),
              const SizedBox(height: 10,),
              buildProfileField('User Name', widget.userName),
              const SizedBox(height: 10,),
              buildProfileField('User Adress', widget.userAddress,multiline: true),
              const SizedBox(height: 10,),
               buildProfileField('User House Name', widget.userHouseName,multiline: true),
              const SizedBox(height: 10,),
               buildProfileField('User House Num', widget.userHouseNum,multiline: true),
              const SizedBox(height: 10,),
               buildProfileField('User locality', widget.locality,multiline: true),
              const SizedBox(height: 10,),
              buildProfileField('User Phone', widget.userPhone),
              const SizedBox(height: 10,),
              buildProfileField('User Gender', widget.userGender),
              const SizedBox(height: 20,),
              SizedBox(
                width: 230,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white
                  ),
                  onPressed: (){

                }, 
                child: const Text('Delete User')),
              )
            ],
          ),
        )
        ),
    );
  }
}