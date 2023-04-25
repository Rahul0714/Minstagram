import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  const CustomTextField(
      {super.key,
      required this.hintText,
      this.obscureText = false,
      required this.controller,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
