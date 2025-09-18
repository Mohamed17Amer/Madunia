import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:madunia/core/services/firebase/firestore/firestore_chat.dart';
import 'package:madunia/features/chat/data/models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  List<MessageModel> messagesList = [];
  var selectChatWaysList = ["محادثة جماعية", "محادثة فردية"];
  BuildContext? groupChatContext;

  ChatCubit() : super(ChatInitial());

  getMessagesSnapshots() {
    try {
      final snapshots = ChatServices.groupChatRef
          .orderBy("createdAt", descending: true)
          .snapshots();
      emit(GetMessagesSnapshotsSuccess(snapshots: snapshots));
      return snapshots;
    } on Exception catch (e) {
      emit(GetMessagesSnapshotsFailure(errMessg: e.toString()));
    }
  }

  getMessages(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    messagesList = [];
    for (int i = 0; i < snapshot.data!.docs.length; i++) {
      messagesList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
    }
    emit(GetMessagesSuccess(messagesList: messagesList));
  }
}
