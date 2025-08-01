import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // FILITR SECTION

  static int currentFilterIndex = 0;

  
  void changeHomeFilterIndex(int index) {
    currentFilterIndex = index;
    emit(HomeChangeFilterIndexState(filterIndex: currentFilterIndex));
  }

  // SHORTS SECTION

  static int currentShortsIndex = 0;

  void changeHomeShortsIndex(int index) {
    currentShortsIndex = index;
    emit(HomeChangeShortsIndexState(shortsIndex: currentShortsIndex));
  }

 
  // AUDIO SECTION

  static int currentAudioIndex = 0;

  void changeHomeAudioIndex(int index) {
    currentAudioIndex = index;
    emit(HomeChangeAudioIndexState(audioIndex: currentAudioIndex));
  }

 
}
