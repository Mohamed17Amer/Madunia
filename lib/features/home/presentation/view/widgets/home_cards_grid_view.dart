import 'package:flutter/material.dart';
import 'package:madunia/features/home/presentation/view/widgets/home_card_item.dart';

class HomeCardsGridView extends StatelessWidget {
  const HomeCardsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) {
        return HomeCardItem();
      },
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: .9,
      ),
    );
  }
}
