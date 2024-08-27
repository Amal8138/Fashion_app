import 'package:fashion/Screens/user/pages/register_complete_page.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/core/constant/const_size.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:fashion/core/constant/text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reEnterPasswordController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _reEnterPasswordController.dispose();
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
                sizedHeight(60),
                const Text(
                  'Create An Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
                const Text(
                  'Fill your information',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                sizedHeight(60),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      textFormField(
                        label: 'Name',
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Name';
                          }
                          return null;
                        },
                      ),
                     sizedHeight(15),
                      textFormField(
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Email';
                          }
                          String pattern = r'^[^@]+@[^@]+\.[^@]+';
                          RegExp regex = RegExp(pattern);
                          if(!regex.hasMatch(value)){
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      sizedHeight(15),
                      textFormField(
                        label: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        obscureText: _obscureTextPassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureTextPassword = !_obscureTextPassword;
                            });
                          },
                          icon: Icon(_obscureTextPassword ? Icons.visibility : Icons.visibility_off),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Password';
                          }
                          else if(value.length < 6){
                            return 'Password Should be minimum 6 letter';
                          }
                          return null;
                        },
                      ),
                     sizedHeight(15),
                      textFormField(
                        label: 'Confirm Password',
                        keyboardType: TextInputType.visiblePassword,
                        controller: _reEnterPasswordController,
                        obscureText: _obscureTextConfirmPassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                            });
                          },
                          icon: Icon(_obscureTextConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Confirm Password';
                          }
                          return null;
                        },
                      ),
                      sizedHeight(30),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              signUpToFirebaseAndHive();
                            }
                          }, 
                          child: const Text('Next')
                        ),
                      )
                    ],
                  )
                )
              ],
            ),
          ),
        )
      ),
    );
  }

  Future<void> signUpToFirebaseAndHive() async {
    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final pass = _passwordController.text.trim();
      final confirmPass = _reEnterPasswordController.text.trim();

      if (pass != confirmPass) {
        showSnackBar(context, 'Password does not match', Colors.red);
      } else {
        UserCredential userdata = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
        String userId = userdata.user!.uid;
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ScreenRegisterNext(userId: userId, userName: name)));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'Password is too weak', Colors.red);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'User already exixts', Colors.red);
      }
    } catch (e) {
      showSnackBar(context, 'An Error occure$e', Colors.red);
    }
  }
}
