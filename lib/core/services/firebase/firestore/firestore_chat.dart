import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  static const String groupChatCollection = 'groupChat';

  static CollectionReference groupChatRef = FirebaseFirestore.instance
      .collection(groupChatCollection);
}
