import 'package:flutter/material.dart';
import 'package:madunia/features/home/presentation/view/widgets/home_cards_grid_view.dart';
import 'package:madunia/features/home/presentation/view/widgets/home_profile_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          // Top safe area spacing
          SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 20))),

          // Profile section
          SliverToBoxAdapter(child: HomeProfileSection()),
          SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Grid view section
          SliverToBoxAdapter(child: HomeCardsGridView()),
        ],
      ),
    );
  }
}
