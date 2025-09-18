import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madunia/core/utils/colors/app_colors.dart';

class CustomTxtFormField extends StatelessWidget {
  // You can add properties here if needed, like controller, decoration, etc.
  // For example:
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final void Function(String)? onSubmitted;

  const CustomTxtFormField({
    super.key,
    required this.controller,
     this.labelText,
     this.validator,
    this.onSubmitted,

    this.keyboardType,
    this.inputFormatters,

    this.hintText,
    this.maxLines = 1,
    this.suffixIcon,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
        suffixIcon:suffixIcon,

        focusColor: AppColors.customAppBarTitleColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.debitReportItemTitleColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide(color: AppColors.homePlayShortsIconColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.debitReportItemTitleColor),
        ),

        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        
      ),
      onFieldSubmitted: onSubmitted,
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,

    );
  }
}
