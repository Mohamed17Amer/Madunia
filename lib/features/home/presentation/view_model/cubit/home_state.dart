part of 'home_cubit.dart';

 class HomeState {}

// initial
final class HomeInitial extends HomeState {}

final class CopyTotalToClipboardSuccess extends HomeState {
  final String total;
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
