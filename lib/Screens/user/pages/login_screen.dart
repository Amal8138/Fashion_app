import 'package:fashion/Screens/user/Widgets/bottom_navigation.dart';
import 'package:fashion/Screens/user/pages/forgot_password.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/core/constant/const_size.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/core/constant/text_form_field.dart';
import 'package:fashion/db/models/db_models.dart';
import 'package:fashion/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                sizedHeight(170),
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                  ),
                ),
                const Text(
                  'Hi, welcome back! You have been missed.',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                sizedHeight(70),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      textFormField(
                        label: 'Username',
                        keyboardType: TextInputType.text,
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Username';
                          }
                          String pattern = r'^[^@]+@[^@]+\.[^@]+';
                          RegExp regex = RegExp(pattern);
                          if(!regex.hasMatch(value)){
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      sizedHeight(20),
                      textFormField(
                        label: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        obscureText: obscureText,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ScreenForgotPassword()));
                          },
                          child: const Text('Forgot Password'),
                        ),
                      ),
                      sizedHeight(20),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              userSignIn();
                            }
                          },
                          child: const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> userSignIn() async {
    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      UserCredential userData = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password);
      var box = await Hive.openBox<UserSignUpModels>('userBox');
      UserSignUpModels? userModel = box.get(userData.user!.uid);
      if (userModel != null && userData.user!.uid == userModel.userId) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const ScreenBottomNavigationBar()),
          (Route<dynamic> route) => false,
        );

        final sharedPrefs = await SharedPreferences.getInstance();
        sharedPrefs.setBool(USER_KEY_VALUE, true);
        showSnackBar(context, 'Loggin Successfully', Colors.green);
      } else {
        showSnackBar(context, 'Invalid user', Colors.red);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, 'Please register$e', Colors.red);
    } catch (e) {
      showSnackBar(context, 'Error Ocuured $e', Colors.red);
    }
  }
}
