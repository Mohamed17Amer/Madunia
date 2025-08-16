import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/features/app/presentation/view_model/cubit/app_cubit.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

part 'repair_request_state.dart';

class RepairRequestCubit extends Cubit<RepairRequestState> {
  RepairRequestCubit() : super(RepairRequestInitial());

  ///*********************** VALIDATIONS ******************************** */

  final TextEditingController repairNameController = TextEditingController();
  final TextEditingController repairDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> repairScreenKey = GlobalKey<FormState>();

  bool checkRequestValidation() {
    if (repairScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  String? validateTxtFormField({
    required String? value,
    required String? errorHint,
  }) {
    if (value == null || value.isEmpty) {
      emit(ValidateTxtFormFieldSuccess());

      return errorHint!;
    }
    emit(ValidateTxtFormFieldFailure());

    return null;
  }

  ///************************* SEND *********************** */

  void sendRepairReuest({required BuildContext context}) async {
    if (checkRequestValidation()) {
      await sendGmailMessage(context).then((v) {
        resetSettings();
      });
    }
  }

  Future<void> sendGmailMessage(BuildContext context) async {
    emit(SendRepairRequestEmailLoading());
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
    final String subject = repairNameController.text.trim();
    final String body = repairDescriptionController.text.trim();

    // receiver server
    final message = Message()
      ..from = Address(username, 'MADUNIA APP from ->  $userUniqueName')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      emit(SendRepairRequestEmailSuccess());
      log('Message sent: $sendReport');
    } catch (e) {
      log('Error sending email: $e');
      emit(SendRepairRequestEmailFailure(errMessg: e.toString()));
    }
  }

  resetSettings() {
    repairNameController.text = "";
    repairDescriptionController.text = "";
  }
}
