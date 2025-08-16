import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/services/firebase_sevices.dart';
import 'package:madunia/core/utils/router/app_screens.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:meta/meta.dart';

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

  void sendAcquirementReuest({BuildContext? context}) {
    if (checkRequestValidation()) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('تم إرسال طلب الصيانة بنجاح')),
      );
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
    final userUniqueName = userNameAuthController.text.trim();


try {
  final user = await firestoreService.getUserByName(userUniqueName);
  
  if (user != null) {
    // Navigate and show success message here
    showToastification(
      context: context,
      message: "تم تسجيل الدخول بنجاح",
    );
    
      navigateReplacementWithGoRouter(
        context: context,
        path: AppScreens.startingScreen,
        extra: user,
      );
      
  } else {
    showToastification(
      context: context,
      message: "لم يتم العثور على المستخدم",
    );
  }
} catch (e) {
  showToastification(
    context: context,
    message: "خطأ في تسجيل الدخول",
  );
}

   
  }
}
