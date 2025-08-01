import 'package:flutter/material.dart';
import 'package:madunia/core/utils/colors/app_colors.dart';

class DebitAppBar extends StatelessWidget {
  const DebitAppBar({super.key});

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
          "كشف المديونية المستحقة عليك",
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
