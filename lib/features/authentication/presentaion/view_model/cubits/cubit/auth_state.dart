part of 'auth_cubit.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

final class ValidateTxtFormFieldSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}

final class ValidateTxtFormFieldFailure extends AuthState {
  @override
  List<Object?> get props => [];
}

final class LoginByUserNameSuccess extends AuthState {
  final AppUser user;
  LoginByUserNameSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

final class LoginByUserNameFailure extends AuthState {
  final String errMessg;
  LoginByUserNameFailure({required this.errMessg});
  @override
  List<Object?> get props => [errMessg];
}

final class LoginByUserNameLoading extends AuthState {
  @override
  List<Object?> get props => [];
}