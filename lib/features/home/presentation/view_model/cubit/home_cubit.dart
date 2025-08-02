import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia/core/helper/helper_funcs.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());


void copyTotalToClipboard(String? total){
  final total =total;
  
copyToClipboard(text: total);
  emit(CopyTotalToClipboardSuccess(total));
}
 
}
