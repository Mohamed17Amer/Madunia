import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia/features/app/presentation/view/widgets/custom_bottom_nav_bar_item.dart';
import 'package:madunia/features/debit_report/presentation/view/pages/debit_screen.dart';
import 'package:madunia/features/home/presentation/view/pages/home_screen.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static int currentIndex = 0;
  static final List<CustomBottomNavBarItem> bottomNavBarItems = [
    CustomBottomNavBarItem(
      pageIcon: Icons.home_outlined,
      pageName: 'Home',
      pageIndex: 0,
    ),
    CustomBottomNavBarItem(
      pageIcon: Icons.money,
      pageName: 'Debit Report',
      pageIndex: 1,
    ),
    CustomBottomNavBarItem(
      pageIcon: Icons.video_library_outlined,
      pageName: 'Youtube',
      pageIndex: 2,
    ),
    CustomBottomNavBarItem(
      pageIcon: Icons.book_outlined,
      pageName: 'Books',
      pageIndex: 3,
    ),
  ];

  static final List<Widget> pagesViews = [
   HomeScreen(),
    DebitScreen(),
    Container(
      color: Colors.transparent,
      child: Center(child: const Text('Youtube')),
    ),
    Container(
      color: Colors.transparent,
      child: Center(child: const Text('Books')),
    ),
  ];

  void changeBottomNavBarIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState(index));
  }
}
