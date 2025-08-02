part of 'repair_request_cubit.dart';

@immutable
sealed class RepairRequestState {}

final class RepairRequestInitial extends RepairRequestState {}

final class ValidateTxtFormFieldSuccess extends RepairRequestState {}
final class ValidateTxtFormFieldFailure extends RepairRequestState {}

