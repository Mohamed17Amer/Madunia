import 'package:flutter/material.dart';
import 'package:madunia/core/utils/colors/app_colors.dart';
import 'package:madunia/features/chat/data/models/message_model.dart';


class SenderChatBubble extends StatelessWidget {
  const SenderChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          color: AppColors.customAppBarTitleColor,
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

