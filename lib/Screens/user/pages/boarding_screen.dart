import 'package:fashion/Screens/user/pages/login_screen.dart';
import 'package:fashion/Screens/user/pages/register_screen.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:flutter/material.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 150,),
            const Text(
              'Welcome To Fashion',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            const SizedBox(height: 70,),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/pexels-karolina-grabowska-5632402.jpg',
                width: 250,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 110,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>  const ScreenRegister()));
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(250, 40)
              ),
              child: const Text('Sign Up'),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ScreenLogin()));
                }, child: const Text('Login in')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
