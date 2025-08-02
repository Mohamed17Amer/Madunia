import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/utils/widgets/custom_icon.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';
import 'package:madunia/features/home/presentation/view_model/cubit/home_cubit.dart';

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
            child: CustomTxt(title: "اسم البيان"),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: CustomTxt(
              title:
                  " 15,000"
                  " جنيه مصري ",
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomLeft,
            child: CustomIcon(
              icon: Icons.copy_all,
              onPressed: () {
                context.read<HomeCubit>().copyTotalToClipboard("total");
              },
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
