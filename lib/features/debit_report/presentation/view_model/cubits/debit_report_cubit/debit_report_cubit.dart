import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/services/firebase_sevices.dart';
import 'package:madunia/core/utils/events/event_bus.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/debit_report/data/models/debit_item_model.dart';

part 'debit_report_state.dart';

class DebitReportCubit extends Cubit<DebitReportState> {
  DebitReportCubit() : super(DebitReportInitial());

  FirestoreService firestoreService = FirestoreService();

  ///******************************* GET ******************************************** */

  Future getAllDebitItems({required String userId}) async {
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
    required String debitItemId,
  }) {
    showToastification(context: context, message: "تم إرسال طلب استفسار");

    // emit(SendAlarmToUserSuccess());
  }

  @override
  Future<void> close() {
    log('', error: 'Debit Report Cubit is Closed');
    return super.close();
  }
}
