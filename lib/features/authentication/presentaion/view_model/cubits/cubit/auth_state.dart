part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}


final class ValidateTxtFormFieldSuccess extends AuthState {}
final class ValidateTxtFormFieldFailure extends AuthState {}
