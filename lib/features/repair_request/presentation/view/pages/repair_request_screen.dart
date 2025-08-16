import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/helper/helper_funcs.dart';
import 'package:madunia/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';
import 'package:madunia/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia/features/repair_request/presentation/view_model/cubit/repair_request_cubit.dart';

class RepairRequestScreen extends StatelessWidget {
  const RepairRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RepairRequestCubit(),
      child: BlocConsumer<RepairRequestCubit, RepairRequestState>(
        listener: (context, state) {
          if (state is SendRepairRequestEmailSuccess) {
            showToastification(
              context: context,
              message: "تم ارسال طلب الصيانة بنجاح",
            );
          } else if (state is SendRepairRequestEmailFailure) {
            showToastification(
              context: context,
              message: "فشل في ارسال طلب الصيانة ",
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: context.read<RepairRequestCubit>().repairScreenKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SafeArea(child: SizedBox(height: 20)),
                    const CustomAppBar(title: "طلب صيانة"),
                    const SizedBox(height: 20),

                    /// اسم الصيانة
                    CustomTxtFormField(
                      labelText: "اسم الصيانة",
                      hintText: "الرجاء إدخال اسم الصيانة",
                      maxLines: 1,
                      validator: (value) {
                        return context
                            .read<RepairRequestCubit>()
                            .validateTxtFormField(
                              value: value,
                              errorHint: "الرجاء إدخال اسم الصيانة",
                            );
                      },
                      controller: context
                          .read<RepairRequestCubit>()
                          .repairNameController,
                    ),
                    const SizedBox(height: 16),

                    /// وصف المشكلة
                    CustomTxtFormField(
                      controller: context
                          .read<RepairRequestCubit>()
                          .repairDescriptionController,
                      labelText: "وصف المشكلة",
                      hintText: "الرجاء إدخال وصف المشكلة",
                      maxLines: 4,
                      validator: (value) {
                        return context
                            .read<RepairRequestCubit>()
                            .validateTxtFormField(
                              value: value,
                              errorHint: "الرجاء إدخال وصف المشكلة",
                            );
                      },
                    ),
                    const SizedBox(height: 24),

                    /// إرسال الزر
                    ElevatedButton(
                      onPressed: state is SendRepairRequestEmailLoading
                          ? null // disable while loading
                          : () {
                              context
                                  .read<RepairRequestCubit>()
                                  .sendRepairReuest(context: context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: state is SendRepairRequestEmailLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const CustomTxt(
                              title: "إرسال الطلب",
                              fontColor: Colors.white,
                            ),
                    ),
                    const SizedBox(height: 40),
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
