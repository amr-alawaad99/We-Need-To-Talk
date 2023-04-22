

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_need_to_talk/shared/main_cubit_states.dart';

import '../module/calls_screen/calls_screen.dart';
import '../module/friends_screen/friends_screen.dart';
import '../module/hallway_screen/hallway_screen.dart';

class MainCubit extends Cubit<MainCubitStates> {

  MainCubit() : super(MainCubitInitialState());

  static MainCubit get(context) => BlocProvider.of(context);

  //  Cubit for BottomNavBar
  int currentIndex = 0;

  void changeBottomNav(int index){
    currentIndex = index;
    emit(ChatChangeBottomNavState());
  }

  List<Widget> screens = [
    const HallWayScreen(),
    const FriendsScreen(),
    const CallsScreen(),
  ];

  List<String> titles = [
    'Hallway',
    'Friends',
    'Calls',
  ];


}