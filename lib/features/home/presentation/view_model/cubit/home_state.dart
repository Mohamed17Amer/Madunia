part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

// initial
final class HomeInitial extends HomeState {}

// filter
final class HomeChangeFilterIndexState extends HomeState {
  final int filterIndex;
  HomeChangeFilterIndexState({required this.filterIndex}) {
    log("filterIndex: $filterIndex ");
  }
}

// shorts
final class HomeChangeShortsIndexState extends HomeState {
  final int shortsIndex;
  HomeChangeShortsIndexState({required this.shortsIndex}) {
    log("shortsIndex: $shortsIndex ");
  }
}

// audio
class HomeChangeAudioIndexState extends HomeState {
  final int audioIndex;
  HomeChangeAudioIndexState({required this.audioIndex}) {
    log("audioIndex: $audioIndex ");
  }
}
