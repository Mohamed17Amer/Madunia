import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madunia/core/services/firebase/firestore/debit_service.dart';
import 'package:madunia/core/services/firebase/firestore/owned_service.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial());

  DebitService debitService = DebitService();
  OwnedService ownedService = OwnedService();

  final userPaymentDetailsCategoriess = ["عليك", "لك"];

  final userOtherDrtailsCategoriess = ["البلاغات"];

  getTotalMoney({required String userId}) async {
    emit(GetTotalMoneyLoading());
    final List<double> total = [0, 0];
    total[0] = await debitService.getTotalDebitMoney(userId);
    total[1] = await ownedService.getTotalOwnedMoney(userId);
    emit(GetTotalMoneySuccess(total: total));
    log('Total Money is $total', name: 'getTotalMoney');
    return total;
  }


  @override
  Future<void> close() {
    log('', error: 'User Details Cubit is Closed');
    return super.close();
  }
}
