import 'package:flutter/material.dart';

class CustomTxtFormField extends StatelessWidget {
  // You can add properties here if needed, like controller, decoration, etc.
  // For example:
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final int? maxLines;

  const CustomTxtFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validator,

    this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,

        border: OutlineInputBorder(),
      ),
      controller: controller,
      validator: validator,
      maxLines: maxLines,
    );
  }
}
