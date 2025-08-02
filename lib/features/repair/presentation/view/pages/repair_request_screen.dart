import 'package:flutter/material.dart';
import 'package:madunia/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia/features/app/presentation/view/widgets/custom_txt_form_field.dart';

class RepairRequestScreen extends StatelessWidget {
  RepairRequestScreen({super.key});
  final GlobalKey<FormState> repairScreenKey = GlobalKey<FormState>();
  final TextEditingController repairNameController = TextEditingController();
  final TextEditingController repairDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: repairScreenKey,
        child: Column(
          children: [
            SafeArea(child: SizedBox(height: 20)),
            CustomAppBar(title: "طلب صيانة"),

            SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: CustomTxtFormField(
                labelText: "اسم الصيانة",
                hintText: "الرجاء إدخال اسم الصيانة",
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم الصيانة';
                  }
                  return null;
                },
                controller: repairNameController,
              ),
            ),
            Expanded(
              flex: 3,
              child: CustomTxtFormField(
                controller: repairDescriptionController,
                labelText: "وصف المشكلة",
                hintText: "الرجاء إدخال وصف المشكلة",
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال وصف المشكلة';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  if (repairScreenKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إرسال طلب الصيانة بنجاح'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple, // Optional: customize color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40), // Makes it oval
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("إرسال الطلب"),
              ),
            ),

            Expanded(flex: 4, child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
