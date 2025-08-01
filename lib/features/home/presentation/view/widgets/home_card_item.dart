import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';

class HomeCardItem extends StatelessWidget {
  const HomeCardItem({super.key});

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              "اسم البيان",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Text(
              " القيمة"
              " جنيه مصري ",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(onPressed: () {}, icon: Icon(Icons.copy_all)),
          ),
        ],
      ),
    );
  }
}
