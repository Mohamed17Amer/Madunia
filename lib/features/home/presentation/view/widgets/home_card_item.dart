import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';

class HomeCardItem extends StatelessWidget {
  const HomeCardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: generateRandomColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "اسم البيان",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),

          Text(
            " القيمة"+ " جنيه مصري ",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
