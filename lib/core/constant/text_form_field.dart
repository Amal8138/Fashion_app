import 'package:flutter/material.dart';

Widget textFormField({
  required String label,
  required TextInputType keyboardType,
  required TextEditingController controller,
  bool obscureText = false,
  String? Function(String?)? validator,
  IconButton? suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      label: Text(label),
      suffixIcon: suffixIcon,
    ),
    validator: validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
  );
}
