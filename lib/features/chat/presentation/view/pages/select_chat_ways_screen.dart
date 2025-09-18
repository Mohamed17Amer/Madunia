import 'package:flutter/material.dart';
import 'package:madunia/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia/features/chat/presentation/view/widgets/select_chat/select_chat_ways_cards_grid_view.dart';

class SelectChatWaysScreen extends StatelessWidget {
  const SelectChatWaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            ..._drawHeader(),
            SliverList(delegate: SliverChildListDelegate(_drawBody())),
          ],
        ),
      ),
    );
  }

  List<Widget> _drawHeader() {
    return <Widget>[
      SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 20))),
      SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  List<Widget> _drawBody() {
    return [
      SelectChatWaysCardsGridView(),

      SizedBox(height: 5),
    ];
  }
}
