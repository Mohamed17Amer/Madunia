import 'package:flutter/material.dart';

class HomeCardsGridView extends StatelessWidget {
  const HomeCardsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(itemBuilder: (context, index) {
      return null;
    }, itemCount: 5,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.8,
    ),
  );
  }
}
