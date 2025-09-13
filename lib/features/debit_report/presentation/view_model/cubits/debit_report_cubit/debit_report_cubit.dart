import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/services/firebase/firestore/debit_service.dart';
import 'package:madunia/features/app/presentation/view_model/cubit/app_cubit.dart';
import 'package:madunia/features/debit_report/data/models/debit_item_model.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

part 'debit_report_state.dart';

class DebitReportCubit extends Cubit<DebitReportState> {
  DebitReportCubit() : super(DebitReportInitial());

  DebitService firestoreService = DebitService();

  ///******************************* GET ******************************************** */

  Future getAllDebitItems({required String userId}) async {
    emit(DebitReportLoading());
    try {
      final allUserItemDebits = await firestoreService.getDebitItems(userId);
      emit(GetAllDebitItemsSuccess(allUserItemDebits: allUserItemDebits));
      log("all debits$allUserItemDebits");
      log("id  $userId");
      return allUserItemDebits;
    } catch (e) {
      emit(GetAllDebitItemsFailure(errmesg: e.toString()));
    }
  }

  ///****************************** Delete ******************************************** */

  ///************************************ VALIDATION **********************************

  /// ******************************** ADD **********************************************

  ///************************************* HELPERS **************************************** */

  sendAcquireToAdmin({
    required BuildContext context,
    required String debitItemTitle,
  }) async {
          showToastification(context: context, message: "برجاء الانتظار...");

    await sendGmailMessage(
      context: context,
      debitItemTitle: debitItemTitle,
    ).then((v) {
      showToastification(context: context, message: "تم إرسال طلب استفسار");
    });

    // emit(SendAlarmToUserSuccess());
  }

  Future<void> sendGmailMessage({
    required BuildContext context,
    required String debitItemTitle,
  }) async {
     // emit(SendRequestEmailLoading());
    // Gmail SMTP configuration
    //sender server
    final String username = 'my.apps.emails17@gmail.com';
    final String password =
        'nvjqugxwejbykqyq'; // Use App Password, not regular password
    final smtpServer = gmail(username, password);

    // sender person

    final String userUniqueName = (context).read<AppCubit>().user.uniqueName;

    // receiver person
    final String recipientEmail = "mo17amer@gmail.com";

    // message
    final String subject = "طلب استفسار ";
    final String body = debitItemTitle.trim();

    // receiver server
    final message = Message()
      ..from = Address(username, 'MADUNIA APP from ->  $userUniqueName')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
     //   emit(SendRequestEmailSuccess());
      log('Message sent: $sendReport');
    } catch (e) {
      log('Error sending email: $e');
     //   emit(SendRequestEmailFailure());
    }
  }

  resetSettings() {}

  @override
  Future<void> close() {
    log('', error: 'Debit Report Cubit is Closed');
    return super.close();
  }
}
