part of 'user_details_cubit.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object?> get props => [];
}

// initial
final class UserDetailsInitial extends UserDetailsState {
  const UserDetailsInitial();
}

final class GetTotalMoneySuccess extends UserDetailsState {
  final List<double> total;
  const GetTotalMoneySuccess({required this.total});

  @override
  List<Object?> get props => [total];
}

final class GetTotalMoneyFailure extends UserDetailsState {
  final String errMesg;
  const GetTotalMoneyFailure({required this.errMesg});

  @override
  List<Object?> get props => [errMesg];
}

final class GetTotalMoneyLoading extends UserDetailsState {
  const GetTotalMoneyLoading();

  @override
  List<Object?> get props => [];
}
