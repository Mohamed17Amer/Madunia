part of 'app_cubit.dart';

@immutable
abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

final class AppInitial extends AppState {
  const AppInitial();
}

final class AppChangeBottomNavBarState extends AppState {
  final int index;
   AppChangeBottomNavBarState(this.index) {
    log("selected index is $index");
  }

  @override
  List<Object?> get props => [index];
}

final class CheckIsLoggedLoading extends AppState {
  const CheckIsLoggedLoading();

  @override
  List<Object?> get props => [];

}

final class CheckIsLoggedSuccess extends AppState {
  final AppUser currentUser;
  const CheckIsLoggedSuccess(this.currentUser);

  @override
  List<Object?> get props => [currentUser];

}

final class CheckIsLoggedFailure extends AppState {
  const CheckIsLoggedFailure();

  @override
  List<Object?> get props => [];

}

