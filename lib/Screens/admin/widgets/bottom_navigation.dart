import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fashion/Screens/admin/pages/select_categories.dart';
import 'package:fashion/Screens/admin/pages/added_products.dart';
import 'package:fashion/Screens/admin/pages/admin_profile.dart';
import 'package:fashion/Screens/admin/pages/all_orders.dart';
import 'package:fashion/Screens/admin/pages/all_users.dart';
import 'package:flutter/material.dart';

class ScreenAdminBottomNavigation extends StatefulWidget {
  const ScreenAdminBottomNavigation({super.key});

  @override
  State<ScreenAdminBottomNavigation> createState() => _ScreenAdminBottomNavigationState();
}

int _currentIndex = 0;

class _ScreenAdminBottomNavigationState extends State<ScreenAdminBottomNavigation> {
  final pages = [
    const ScreenSelectingCategories(),
    const ScreenAdminAllAddedProducts(),
    const ScreenAdminAllUsers(),
    const ScreenAdminAllOrders(),
    const ScreenAdminProfile()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Icon(Icons.home),
          Icon(Icons.production_quantity_limits_outlined),
          Icon(Icons.people_outline),
          Icon(Icons.shopping_bag_outlined),
          Icon(Icons.person_2_outlined)
        ]
        ),
        body: pages[_currentIndex],
    );
  }
}