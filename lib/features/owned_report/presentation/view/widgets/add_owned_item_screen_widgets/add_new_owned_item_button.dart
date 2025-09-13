import 'package:flutter/material.dart';
import 'package:madunia/core/utils/colors/app_colors.dart';
import 'package:madunia/core/utils/widgets/custom_icon.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';

class AddNewOwnedItemButton extends StatelessWidget {
  final AppUser user;
  const AddNewOwnedItemButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
    
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomIcon(
            icon: Icons.add_circle_outline_rounded,
            color: AppColors.homeAppBarIconsBackgroundColor,
          ),
          CustomTxt(title: "أضف عنصرًا جديدًا للمديونية"),
        ],
      ),
    );
  }
}
