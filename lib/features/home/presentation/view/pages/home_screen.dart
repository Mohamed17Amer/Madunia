import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Expanded(
      flex: 1,

      child: Column(
        
        
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SafeArea(child: SizedBox(height: 20)),
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.deepPurple,
            
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/shorts_place_holder.png'),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'name',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          
        ],
      ),
    ) ;
  }
}
