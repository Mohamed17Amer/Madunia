import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';

class DebitReportItem extends StatelessWidget {
  const DebitReportItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality (
      textDirection: TextDirection.rtl,
      child: SizedBox(
        //height: MediaQuery.of(context).size.height*.2,
        child: ListTile(
          title: const Text("اسم البيان", style: TextStyle(fontSize: 24)),
          subtitle: const Text(
            "القيمة  "
            "جنيه مصري",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.check)),
          trailing: IconButton(
            onPressed: () {
              showToastification(context: context, message: "تم إرسال طلب استفسار");
            },
            icon: const Icon(Icons.question_mark),
          ),
        ),
      ),
    );
  }
}
