import 'package:fashion/Screens/user/pages/terms_and_condition.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:fashion/Screens/user/pages/user_profile.dart';
import 'package:fashion/Screens/user/pages/privacy_policy.dart';
import 'package:fashion/Screens/user/pages/boarding_screen.dart';
import 'package:fashion/Screens/admin/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenAccount extends StatelessWidget {
  const ScreenAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserSignUpModels?>(
      future: _fetchUserDetails(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No user data available'));
        }

        final user = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Are You Admin'),
                        content: const Text('Are you sure'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (ctx) => const ScreenAdminLogin(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.admin_panel_settings_outlined),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
               CircleAvatar(
                backgroundColor: backgroundColors,
                radius: 60,
                backgroundImage: user.userImage.isNotEmpty
                    ? MemoryImage(user.userImage)
                    : null,
                child: user.userImage.isEmpty
                    ? const Icon(Icons.person, size: 60, color: Colors.black)
                    : null,
              ),
              const SizedBox(height: 10),
              Text(
                user.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 35),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) =>  UserProfile(user: user)),
                  );
                },
                child: const SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.person_2_outlined),
                        Text('Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                        ),
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const ScreenPrivacyAndPolicy()),
                  );
                },
                child: const SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.privacy_tip_outlined),
                        Text('Privacy Policy',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                        ),
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const ScreenTermsAndConditions()),
                  );
                },
                child: const SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.privacy_tip_outlined),
                        Text('Terms And Condition',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                        ),
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  userLogOut(context);
                },
                child: const SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.logout),
                        Text('Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                        ),
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(), 
              const Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<UserSignUpModels?> _fetchUserDetails() async {
    try {
      var box = await Hive.openBox<UserSignUpModels>('userBox');
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return null;
      return box.get(userId);
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      return null;
    }
  }

  Future<void> userLogOut(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are You Sure'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _userLogOut(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _userLogOut(BuildContext context) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const BoardingScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
