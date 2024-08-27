import 'package:fashion/Screens/user/Widgets/bottom_navigation.dart';
import 'package:fashion/Screens/user/pages/boarding_screen.dart';
import 'package:fashion/core/colors/colors.dart';
import 'package:fashion/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenAnimatedSplash extends StatefulWidget {
  const ScreenAnimatedSplash({super.key});

  @override
  State<ScreenAnimatedSplash> createState() => _ScreenAnimatedSplashState();
}

class _ScreenAnimatedSplashState extends State<ScreenAnimatedSplash> with SingleTickerProviderStateMixin {

  late final AnimationController animationController = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this);

    @override
  void initState() {
    animationController.forward();
    checkSharedPreferences();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final Animation<double> fadeAnimator = CurvedAnimation(parent: animationController, curve: Curves.decelerate);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(opacity: fadeAnimator,
        child: const SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius:16,
                backgroundColor: primaryColor,
                child: Center(
                  child: Text('f',style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold,fontSize: 15),),
                ),
              ),
            ),
            SizedBox(width: 5,),
            Align(
              alignment: Alignment.center,
              child: Text('fashion',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white
              ),
              ),
            )
          ],
        )
        ),
        )
      ),
    );
  }
  Future<void> gotoBoardingScreen() async{
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) =>const BoardingScreen()), (Route<dynamic> route) => false);
  }

  Future<void> checkSharedPreferences() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final _data = sharedPrefs.getBool(USER_KEY_VALUE);

    if(_data == null || _data == false){
      gotoBoardingScreen();
    }
    else{
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const ScreenBottomNavigationBar()), 
        (Route<dynamic> route) => false);
    }
  }
}