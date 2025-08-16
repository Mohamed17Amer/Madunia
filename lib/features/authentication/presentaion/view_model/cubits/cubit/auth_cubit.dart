import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:madunia/core/services/firebase_sevices.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/app/data/models/user_storage_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  FirestoreService firestoreService = FirestoreService();
  final TextEditingController userNameAuthController = TextEditingController();
  final GlobalKey<FormState> authScreenKey = GlobalKey<FormState>();

  bool checkRequestValidation() {
    if (authScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void sendloginReuest({BuildContext? context}) {
    if (checkRequestValidation()) {
      loginByUserName(context: context!);
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

  Future<void> loginByUserName({required BuildContext context}) async {
    emit(LoginByUserNameLoading());
    final userUniqueName = userNameAuthController.text.trim();

    try {
      final user = await firestoreService.getUserByName(userUniqueName);

      if (user != null) {
        // Navigate and show success message here
        emit(LoginByUserNameSuccess(user: user));
        await UserStorage.saveUser(username: user.uniqueName, userId: user.id);
      } else {
        resetSettings();
        emit(LoginByUserNameFailure(errMessg: "لم يتم العثور على المستخدم"));
      }
    } catch (e) {
      emit(LoginByUserNameFailure(errMessg: e.toString()));
      log("error in login is   : $e");
    }
  }

  resetSettings() {
    userNameAuthController.text = "";
  }
}
