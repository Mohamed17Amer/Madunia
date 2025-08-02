import 'package:flutter/material.dart';
import 'package:madunia/core/utils/colors/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.00),
      decoration: BoxDecoration(
        color: Colors.transparent,

        border: Border.all(
          width: 2.00,
          strokeAlign: BorderSide.strokeAlignInside,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12.00),
      ),
      height: 80,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 30,
            color: AppColors.bottomNavBarSelectedItemColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
