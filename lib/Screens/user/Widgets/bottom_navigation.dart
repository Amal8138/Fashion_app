import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fashion/Screens/user/pages/account.dart';
import 'package:fashion/Screens/user/pages/cart.dart';
import 'package:fashion/Screens/user/pages/home_screen.dart';
import 'package:fashion/Screens/user/pages/all_orders.dart';
import 'package:fashion/Screens/user/pages/wislist.dart';
import 'package:flutter/material.dart';

class ScreenBottomNavigationBar extends StatefulWidget {
  const ScreenBottomNavigationBar({super.key});

  @override
  State<ScreenBottomNavigationBar> createState() => _ScreenBottomNavigationBarState();
}
 int _currentIndex = 0;

class _ScreenBottomNavigationBarState extends State<ScreenBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final pages = [
      const ScreenHome(),
      const ScreenWishList(),
      const ScreenCart(),
      const ScreenAllOrders(),
      const ScreenAccount()
    ];
    return  Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        height: 60,
        animationCurve: Curves.decelerate,
        backgroundColor: Colors.black,
        color: Colors.teal.shade200,
        items: const [
          Icon(Icons.home_outlined),
          Icon(Icons.favorite_border),
          Icon(Icons.shopping_cart_outlined),
          Icon(Icons.grid_view),
          Icon(Icons.account_circle_outlined)
        ]
        ),
        body: pages[_currentIndex],
    );
  }
}