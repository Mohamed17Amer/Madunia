import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/services/firebase/firestore/firestore_chat.dart';
import 'package:madunia/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia/features/app/presentation/view_model/cubit/app_cubit.dart';

class SendMessgTxtFormField extends StatelessWidget {
  final ScrollController chatListViewController;
  SendMessgTxtFormField({super.key, required this.chatListViewController});
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CustomTxtFormField(
          controller: controller,
          hintText: 'Send Message',
          suffixIcon: Icon(Icons.send, color: Colors.amberAccent),
          onSubmitted: (data) async {
            if (data.trim().isEmpty) return;
            final mes = await ChatServices.groupChatRef.add({
              "message": data,
              "createdAt": DateTime.now(),
              "id": context.read<AppCubit>().currentUser.id,
            });
            log(mes.toString());

            controller.clear();
            if (chatListViewController.hasClients) {
              chatListViewController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            }
          },
        ),
      ),
    );
  }
}
