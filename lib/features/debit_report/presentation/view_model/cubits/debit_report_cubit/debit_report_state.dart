part of 'debit_report_cubit.dart';

@immutable
///**************** INITIALS ************************ */
abstract class DebitReportState extends Equatable {
  const DebitReportState();

  @override
  List<Object?> get props => [];
}

final class DebitReportInitial extends DebitReportState {
  const DebitReportInitial();
}

final class DebitReportLoading extends DebitReportState {
  @override
  List<Object?> get props => [];
}


///************************ GET *************************** */
final class GetAllDebitItemsSuccess extends DebitReportState {
  final List<DebitItem> allUserItemDebits;

  GetAllDebitItemsSuccess({required this.allUserItemDebits}) {
    debugPrint("debits$allUserItemDebits");
  }

  @override
  List<Object?> get props => [allUserItemDebits];
}

final class GetAllDebitItemsFailure extends DebitReportState {
  final String errmesg;
  const GetAllDebitItemsFailure({required this.errmesg});

  @override
  List<Object?> get props => [errmesg];
}

///********************** DELETE ********************************* */
///****************** VALIDATION ********************** */

final class ValidateTxtFormFieldSuccess extends DebitReportState {
  const ValidateTxtFormFieldSuccess();
}

final class ValidateTxtFormFieldFailure extends DebitReportState {
  const ValidateTxtFormFieldFailure();
}

///****************** ADD ********************** */


///************************ SEND **************************** */


final class SendRequestEmailLoading extends DebitReportState {
  @override
  List<Object?> get props => [];
}

final class SendRequestEmailSuccess extends DebitReportState {
  @override
  List<Object?> get props => [];
}

final class SendRequestEmailFailure extends DebitReportState {
  @override
  List<Object?> get props => [];
}
