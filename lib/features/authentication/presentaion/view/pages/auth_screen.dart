import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/utils/router/app_screens.dart';
import 'package:madunia/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';
import 'package:madunia/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia/features/authentication/presentaion/view_model/cubits/cubit/auth_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return CustomScaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: context.read<AuthCubit>().authScreenKey,
                child: Column(
                  children: [
                    SafeArea(child: SizedBox(height: 20)),
                    CustomAppBar(title: "تسجيل دخول باسم المستخدم"),

                    SizedBox(height: 20),
                    Expanded(
                      flex: 2,
                      child: CustomTxtFormField(
                        labelText: "اسم المستخدم المميز",
                        hintText:
                            "الرجاء إدخال اسم المستخدم المُستلم من الأدمن",
                        maxLines: 1,
                        validator: (value) {
                          return context.read<AuthCubit>().validateTxtFormField(
                            value: value,
                            errorHint: "الرجاء إدخال الاسم المميز بطريقة صحيحة",
                          );
                        },
                        controller: context
                            .read<AuthCubit>()
                            .userNameAuthController,
                      ),
                    ),

                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is LoginByUserNameSuccess) {
                          showToastification(
                            context: context,
                            message: "تم تسجيل الدخول بنجاح",
                          );

                          navigateReplacementWithGoRouter(
                            context: context,
                            path: AppScreens.startingScreen,
                            extra: state.user,
                          );
                        } else if (state is LoginByUserNameFailure) {
                          showToastification(
                            context: context,
                            message: '''راجع الاتصال بالانترنت أو راجع الأدمن
                            لم يتم العثور على المستخدم''',
                          );
                        } else if (state is LoginByUserNameLoading) {
                          Expanded(
                            flex: 1,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },

                      builder: (context, state) {
                        return Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AuthCubit>().sendloginReuest(
                                context: context,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Optional: customize color
                              padding: const EdgeInsets.symmetric(
                                horizontal: 100,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  40,
                                ), // Makes it oval
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const CustomTxt(
                              title: "تسجيل الدخول",
                              fontColor: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),

                    Expanded(flex: 4, child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
