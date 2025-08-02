import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/utils/colors/app_colors.dart';
import 'package:madunia/core/utils/widgets/custom_icon.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';

class DebitReportItem extends StatelessWidget {
  const DebitReportItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        //height: MediaQuery.of(context).size.height*.2,
        child: ListTile(
          title: const CustomTxt(
            title: "اسم البيان",
            fontColor: AppColors.debitReportItemTitleColor,
          ),
          subtitle: const CustomTxt(
            title:
                "القيمة  "
                "جنيه مصري",
            fontWeight: FontWeight.bold,
            fontColor: AppColors.debitReportItemSubTitleColor,
          ),
          leading: CustomIcon(
            onPressed: () {},
            icon: Icons.check,
          ),
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
