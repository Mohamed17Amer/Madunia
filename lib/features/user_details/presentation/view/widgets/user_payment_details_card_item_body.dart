import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/services/firebase_sevices.dart';
import 'package:madunia/core/utils/widgets/custom_icon.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserPaymentDetailsCardItemBody extends StatelessWidget {
  final AppUser? user;
  final int? index;
  final double? total;

  UserPaymentDetailsCardItemBody({super.key, this.user, this.index, required this. total});

  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // debit item name
        Align(
          alignment: Alignment.topRight,
          child: CustomTxt(
            title: context
                .read<UserDetailsCubit>()
                .userPaymentDetailsCategoriess[index!],
            fontWeight: FontWeight.bold,
          ),
        ),

        // debit item value
        Align(
          alignment: Alignment.topLeft,
          child: CustomTxt(
            title: "$total جنيه مصري ",
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        // debit item copy
        Align(
          alignment: Alignment.bottomLeft,
          child: CustomIcon(
            icon: Icons.copy_all,
            onPressed: () {
             copyToClipboard(text: "total");
            },
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
