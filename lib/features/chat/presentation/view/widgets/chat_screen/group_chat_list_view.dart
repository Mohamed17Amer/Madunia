import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/features/app/presentation/view_model/cubit/app_cubit.dart';
import 'package:madunia/features/chat/presentation/view/widgets/chat_screen/receiver_chat_bubble.dart';
import 'package:madunia/features/chat/presentation/view/widgets/chat_screen/sender_chat_buble.dart';
import 'package:madunia/features/chat/presentation/view_model/cubit/chat_cubit.dart';

class GroupChatListView extends StatelessWidget {
  final ScrollController chatListViewController;
  const GroupChatListView({super.key, required this.chatListViewController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is GetMessagesSnapshotsSuccess) {
        }
      },
      builder: (context, state) {
     

        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: chatListViewController,
            itemCount: context.read<ChatCubit>().messagesList.length,
            itemBuilder: (context, index) {
              final message = context.read<ChatCubit>().messagesList[index];
              final currentUserId = context.read<AppCubit>().currentUserId;
             
              return (message.id == currentUserId)
                  ? SenderChatBubble(message: message)
                  : RecevierChatBubble(message: message);
            },
          ),
        );
      },
    );
  }
}
