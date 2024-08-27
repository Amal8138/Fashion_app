import 'package:fashion/Screens/admin/widgets/bottom_navigation.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/core/constant/snack_bar.dart';
import 'package:flutter/material.dart';

class ScreenAdminLogin extends StatefulWidget {
   const ScreenAdminLogin({super.key});

  @override
  State<ScreenAdminLogin> createState() => _ScreenAdminLoginState();
}

class _ScreenAdminLoginState extends State<ScreenAdminLogin> {
  final TextEditingController _usernameController = TextEditingController();

    final TextEditingController _passwordController = TextEditingController();

    bool _obsqureText = true;

 @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 170,),
                const Text('Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25
                ),
                ),
                const Text('Hey Admin Welcome Back.',
                style: TextStyle(
                  color: Colors.grey
                ),
                ),
                const SizedBox(height: 70,),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          label: const Text('Username'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obsqureText,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          label: const Text('Password'),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                _obsqureText = !_obsqureText;
                              });
                            }, 
                            icon: Icon(_obsqureText ? Icons.visibility : Icons.visibility_off)
                            )
                        ),
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            adminLogin(context);
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

  Future<void> adminLogin(BuildContext context) async{
    final user = _usernameController.text.trim();
    final pass = _passwordController.text.trim();

    const username = 'amalanil8138@gmail.com';
    const password = 'amalanil';

    if(user == username && pass == password){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) =>  const ScreenAdminBottomNavigation()),
         (Route<dynamic> route) => false);
    }
    else{
      showSnackBar(context, 'Username and password does not matching', Colors.red);
    }
  }
}