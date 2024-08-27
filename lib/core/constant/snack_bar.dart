import 'package:flutter/material.dart';

void showSnackBar(BuildContext context , String text , Color color){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(12),
    backgroundColor: color,
    content: Text(text)));
}