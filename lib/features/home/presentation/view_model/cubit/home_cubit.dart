import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:madunia/core/helper/helper_funcs.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());


void copyTotalToClipboard(String? total){
  final String total = "total";
  copyToClipboard(text: total);
  emit(CopyTotalToClipboardSuccess(total));
}
 
}
