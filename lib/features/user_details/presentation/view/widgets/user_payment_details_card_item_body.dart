import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/services/firebase_sevices.dart';
import 'package:madunia/core/utils/widgets/custom_icon.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';
import 'package:madunia/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserPaymentDetailsCardItemBody extends StatefulWidget {
  final int? index;
  final double? total;

  UserPaymentDetailsCardItemBody({super.key, this.index, required this.total});

  @override
  State<UserPaymentDetailsCardItemBody> createState() =>
      _UserPaymentDetailsCardItemBodyState();
}

class _UserPaymentDetailsCardItemBodyState
    extends State<UserPaymentDetailsCardItemBody> {
  late String categoryName;
  FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    categoryName = (context)
        .read<UserDetailsCubit>()
        .userPaymentDetailsCategoriess[widget.index!];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // debit item name
        Align(
          alignment: Alignment.topRight,
          child: CustomTxt(title: categoryName, fontWeight: FontWeight.bold),
        ),

        // debit item value
        Align(
          alignment: Alignment.topLeft,
          child: CustomTxt(
            title: "${widget.total} جنيه مصري ",
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
              copyToClipboard(text: "$categoryName  : ${widget.total}");
            },
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
