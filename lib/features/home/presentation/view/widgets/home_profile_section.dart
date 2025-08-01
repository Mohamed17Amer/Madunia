import 'package:flutter/material.dart';

class HomeProfileSection extends StatelessWidget {
  const HomeProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundColor: Colors.deepPurple,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
              'assets/images/shorts_place_holder.png',
            ),
          ),
        ),

        const SizedBox(height: 5),
        const Text(
          'name',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
