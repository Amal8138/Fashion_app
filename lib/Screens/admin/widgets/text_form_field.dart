import 'package:flutter/material.dart';

class DetailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  const DetailTextFormField({
    Key?key,
    required this.controller,
    required this.label,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text(label),
      ),
      validator: validator,
      autovalidateMode: autovalidateMode,
    );
  }
}
