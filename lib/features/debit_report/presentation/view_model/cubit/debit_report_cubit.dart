import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:meta/meta.dart';

part 'debit_report_state.dart';

class DebitReportCubit extends Cubit<DebitReportState> {
  DebitReportCubit() : super(DebitReportInitial());

  void sendItemInquiryRequest({required BuildContext context}) {
    showToastification(context: context, message: "تم إرسال طلب استفسار");

    emit(SendItemInquiryRequestSuccess());
  }
}
