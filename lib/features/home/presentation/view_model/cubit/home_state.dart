import 'dart:developer';


part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

// initial
final class HomeInitial extends HomeState {}

final class CopyTotalToClipboardSuccess extends HomeState {
  final double total;
  CopyTotalToClipboardSuccess(this.total) {
    log("home_cubit   total = $total ");
  }
}


final class CopyTotalToClipboardFailure extends HomeState {
  final  String errorMesg;
  CopyTotalToClipboardFailure(this.errorMesg)
     {
      log ("home_cubit   errorMesg = $errorMesg ");
    }

}
