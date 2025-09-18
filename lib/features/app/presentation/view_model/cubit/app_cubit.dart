import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:madunia/core/services/firebase/user_service.dart';
import 'package:madunia/features/app/data/models/app_user_model.dart';
import 'package:madunia/features/app/data/models/user_storage_model.dart';
import 'package:madunia/features/app/presentation/view/widgets/custom_bottom_nav_bar_item.dart';
import 'package:madunia/features/chat/presentation/view/pages/select_chat_ways_screen.dart';
import 'package:madunia/features/debit_report/presentation/view/pages/debit_screen.dart';
import 'package:madunia/features/instructions/presentation/view/pages/annimated_instructions_screen.dart';
import 'package:madunia/features/repair_request/presentation/view/pages/repair_request_screen.dart';
import 'package:madunia/features/user_details/presentation/view/pages/user_details_screen.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  UserService firestoreService = UserService();

  late AppUser currentUser;
  late String currentUserId;
  late String currentUsername;

  static int currentIndex = 0;

  static final List<Widget> pagesViews = [
    UserDetailsScreen(),
    DebitScreen(),
    RepairRequestScreen(),
    SelectChatWaysScreen(),
    AnimatedInstructionsScreen(),
  ];

  static final List<CustomBottomNavBarItem> bottomNavBarItems = [
    CustomBottomNavBarItem(
      pageIcon: Icons.home_outlined,
      pageName: 'User Details',
      pageIndex: 0,
    ),
    CustomBottomNavBarItem(
      pageIcon: Icons.money,
      pageName: 'Debit Report',
      pageIndex: 1,
    ),
    CustomBottomNavBarItem(
      pageIcon: Icons.home_repair_service,
      pageName: 'Repair Request',
      pageIndex: 2,
    ),
     CustomBottomNavBarItem(
      pageIcon: Icons.chat,
      pageName: 'chat ways',
      pageIndex: 3,
    ),
    CustomBottomNavBarItem(
      pageIcon: Icons.integration_instructions,
      pageName: 'Sustainable instructions',
      pageIndex: 4,
    ),
  ];

  void changeBottomNavBarIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState(index));
  }


   void checkLoginStatus() async {
    bool isLoggedIn = await UserStorage.isLoggedIn();

    if (isLoggedIn) {
       currentUsername = (await UserStorage.getUsername())!;
       currentUserId = (await UserStorage.getUserId())!;
        currentUser = (await  firestoreService.getUserByName(currentUsername!))! ;
        emit(CheckIsLoggedSuccess(currentUser));

      // User is logged in, go to home
     
    } else {
      emit(CheckIsLoggedFailure());
      // User not logged in, go to login
    
    }
  }
}
