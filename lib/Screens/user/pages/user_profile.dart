import 'package:fashion/Screens/user/Widgets/text_field.dart';
import 'package:fashion/Screens/user/Widgets/update_user_widget.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final UserSignUpModels user;
  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late UserSignUpModels _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _updateUser(UserSignUpModels updatedUser) {
    setState(() {
      _user = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(4), 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.teal.shade300, width: 3),
                  ),
                  child:  CircleAvatar(
                    radius: 60,
                    backgroundColor: primaryColor,
                    child:_user.userImage.isNotEmpty ? ClipOval(
                      child: Image.memory(_user.userImage,height: 120,width: 120,fit: BoxFit.cover,),
                    ): const Icon(Icons.person)
                  )
                ),
                const SizedBox(height: 20),
                buildProfileField('Name',_user.userName),
                const SizedBox(height: 15),
                buildProfileField('Phone',_user.userPhone),
                const SizedBox(height: 15),
                buildProfileField('Address',_user.userAddress,multiline: true),
                const SizedBox(height: 15),
                buildProfileField('House name ',_user.houseName),
                const SizedBox(height: 15),
                buildProfileField('House num ',_user.houseNumber),
                const SizedBox(height: 15),
                buildProfileField('Gender ',_user.locality),
                const SizedBox(height: 15),
                buildProfileField('Gender ',_user.userGender),
                const SizedBox(height: 15),
                
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final updatedUser = await showDialog<UserSignUpModels>(
                        context: context,
                        builder: (ctx) {
                          return UpdateUserWidget(
                            user: _user,
                            onUpdate: _updateUser,
                          );
                        },
                      );

                      if (updatedUser != null) {
                        setState(() {
                          _user = updatedUser;
                        });
                      }
                    },
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
