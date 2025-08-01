import 'package:flutter/material.dart';
import 'package:madunia/core/utils/colors/app_colors.dart';
import 'package:madunia/features/debit_report/presentation/view/widgets/debit_app_bar.dart';
import 'package:madunia/features/debit_report/presentation/view/widgets/debit_report_item.dart';
import 'package:madunia/features/debit_report/presentation/view/widgets/debit_sliver_list.dart';

class DebitScreen extends StatelessWidget {
  const DebitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 20))),
          SliverToBoxAdapter(child: DebitAppBar()),

          SliverToBoxAdapter(child: SizedBox(height: 20)),
          DebitSliverList(),
        ],
      ),
    );
  }
}
