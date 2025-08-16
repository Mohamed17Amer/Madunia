part of 'repair_request_cubit.dart';

@immutable
sealed class RepairRequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class RepairRequestInitial extends RepairRequestState {
  @override
  List<Object?> get props => [];
}

final class ValidateTxtFormFieldSuccess extends RepairRequestState {
  @override
  List<Object?> get props => [];
}

final class ValidateTxtFormFieldFailure extends RepairRequestState {
  @override
  List<Object?> get props => [];
}

final class SendRepairRequestEmailLoading extends RepairRequestState {
  @override
  List<Object?> get props => [];
}

final class SendRepairRequestEmailSuccess extends RepairRequestState {
  @override
  List<Object?> get props => [];
}

final class SendRepairRequestEmailFailure extends RepairRequestState {
  final String errMessg;
  SendRepairRequestEmailFailure({required this.errMessg});
  @override
  List<Object?> get props => [errMessg];
}
