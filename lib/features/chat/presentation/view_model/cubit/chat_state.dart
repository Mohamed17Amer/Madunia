part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}
final class GetMessagesSuccess extends ChatState{
final List messagesList;
const GetMessagesSuccess({required this.messagesList});
}


final class GetMessagesFailure extends ChatState{
  final String errMessg;
 const GetMessagesFailure({required this.errMessg});
}

final class GetMessagesSnapshotsSuccess extends ChatState{
  final Stream<QuerySnapshot> snapshots;
  const GetMessagesSnapshotsSuccess({required this.snapshots});
}

final class GetMessagesSnapshotsFailure extends ChatState{
  final String errMessg;
 const GetMessagesSnapshotsFailure({required this.errMessg});
}