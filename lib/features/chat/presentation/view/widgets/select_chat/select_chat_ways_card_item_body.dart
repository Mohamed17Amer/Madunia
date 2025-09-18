import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';
import 'package:madunia/features/chat/presentation/view_model/cubit/chat_cubit.dart';
class SelectChataysCardItemBody extends StatelessWidget {
  final int? index;
  const SelectChataysCardItemBody({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: CustomTxt(
            title: context
                .read<ChatCubit>()
                .selectChatWaysList[index!],
            fontWeight: FontWeight.bold,
          ),
        ),

        Align(
          alignment: Alignment.topLeft,
          child: CustomTxt(title: "", fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),

      ],
    );
  }
}
