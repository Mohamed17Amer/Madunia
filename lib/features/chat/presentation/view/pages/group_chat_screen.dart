import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/services/firebase_services.dart';
import 'package:madunia/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia/features/chat/presentation/view/widgets/chat_screen/group_chat_list_view.dart';
import 'package:madunia/features/chat/presentation/view/widgets/chat_screen/send_messg_txt_form_field.dart';
import 'package:madunia/features/chat/presentation/view_model/cubit/chat_cubit.dart';

class GroupChatScreen extends StatelessWidget {
  final chatListViewController = ScrollController();

  ChatServices chatServices = ChatServices();

  GroupChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: context.read<ChatCubit>().getMessagesSnapshots(),

        builder: (context, snapshot) {
          if (snapshot.hasData) {
            context.read<ChatCubit>().getMessages(snapshot);

            return Column(
              children: [
                SafeArea(child: CustomAppBar(title: "Group Chat")),
                
                SizedBox(height: 10),

                GroupChatListView(
                  chatListViewController: chatListViewController,
                ),
                SendMessgTxtFormField(
                  chatListViewController: chatListViewController,
                ),

                SizedBox(height: 40),
              ],
            );
          } else {
            return SendMessgTxtFormField(
              chatListViewController: chatListViewController,
            );
          }
        },
      ),
    );
  }
}
