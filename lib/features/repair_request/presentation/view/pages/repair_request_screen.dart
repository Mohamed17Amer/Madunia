import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia/core/utils/widgets/custom_txt.dart';
import 'package:madunia/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia/features/repair_request/presentation/view_model/cubit/repair_request_cubit.dart';

class RepairRequestScreen extends StatelessWidget {
  RepairRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RepairRequestCubit(),
      child: BlocBuilder<RepairRequestCubit, RepairRequestState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: context.read<RepairRequestCubit>().repairScreenKey,
              child: Column(
                children: [
                  SafeArea(child: SizedBox(height: 20)),
                  CustomAppBar(title: "طلب صيانة"),

                  SizedBox(height: 20),
                  Expanded(
                    flex: 2,
                    child: CustomTxtFormField(
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
                  ),
                  Expanded(
                    flex: 3,
                    child: CustomTxtFormField(
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
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<RepairRequestCubit>().sendRepairReuest(
                          context: context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Optional: customize color
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
                        title: "إرسال الطلب",
                        fontColor: Colors.white,
                      ),
                    ),
                  ),

                  Expanded(flex: 4, child: SizedBox(height: 20)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
