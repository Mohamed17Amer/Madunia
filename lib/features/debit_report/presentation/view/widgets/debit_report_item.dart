import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/utils/widgets/custom_icon.dart';

class DebitReportItem extends StatelessWidget {
  const DebitReportItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
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
          leading: CustomIcon(onPressed: () {}, icon: Icons.check),
          trailing: CustomIcon(
            onPressed: () {
              showToastification(
                context: context,
                message: "تم إرسال طلب استفسار",
              );
            },
            icon: Icons.question_mark,
          ),
        ),
      ),
    );
  }
}
