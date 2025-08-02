import 'package:flutter/material.dart';
import 'package:madunia/core/utils/colors/app_colors.dart';
import 'package:madunia/features/debit_report/presentation/view/widgets/debit_report_item.dart';

class DebitSliverList extends StatelessWidget {
  const DebitSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemBuilder: (BuildContext context, int index) {
        return DebitReportItem();
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          thickness: 2,
          color: AppColors.bottomNavBarSelectedItemColor,
        );
      },
    );
  }
}
