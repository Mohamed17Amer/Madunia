import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';

class CustomSquareCardItemContainer extends StatelessWidget {
  Widget? itemBody;
  CustomSquareCardItemContainer({super.key, required this.itemBody});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: generateRandomColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: itemBody,
    );
  }
}
