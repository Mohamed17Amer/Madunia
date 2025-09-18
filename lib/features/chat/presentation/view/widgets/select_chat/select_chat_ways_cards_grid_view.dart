import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/utils/router/app_screens.dart';
import 'package:madunia/core/utils/widgets/custom_square_card_item.dart';
import 'package:madunia/features/chat/presentation/view/widgets/select_chat/select_chat_ways_card_item_body.dart';
import 'package:madunia/features/chat/presentation/view_model/cubit/chat_cubit.dart';
class SelectChatWaysCardsGridView extends StatelessWidget {
  const SelectChatWaysCardsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            switch (index) {
              case 0:
              
                navigateToWithGoRouter(
                  context: context,
                  path: AppScreens.groupChatScreen,
                );
              case 1:
                  navigateToWithGoRouter(
                  context: context,
                  path: AppScreens.individualChatScreen,
                );
            }
          },

          child: CustomSquareCardItem(
            itemBody: SelectChataysCardItemBody(index: index),
            flag: "adding_debit_ways",
          ),
        );
      },
      itemCount: context
          .read<ChatCubit>()
          .selectChatWaysList
          .length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
    );
  }
}
