import 'package:flutter/material.dart';
import 'package:madunia/core/utils/widgets/custom_square_card_item_container.dart';

class CustomSquareCardItem extends StatelessWidget {
  final Widget itemBody;
  final String flag;
  const CustomSquareCardItem({required this.itemBody, required this.flag});

  @override
  Widget build(BuildContext context) {
    return CustomSquareCardItemContainer(itemBody: itemBody);
  }
}
