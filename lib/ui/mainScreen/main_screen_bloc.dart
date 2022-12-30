import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helper/shared_preference_helper.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends Cubit<MainScreenState> {
  final SharedPreferenceHelper _sharedPrefHelper = SharedPreferenceHelper();

  MainScreenBloc() : super(const MainScreenState.initial());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Key inputKey = GlobalKey();
  BuildContext? textFieldContext;

  void updateIndex(index) {
    print('htytytyry');
    if (index != state.index) {
      emit(state.copyWith(index: index));
    }
  }
  void updateBottomIndex(index) {
    if (index != state.bottomIndex) {
      emit(state.copyWith(bottomIndex: index));
    }
  }

  void updateSelectedIndex(index) {
    if (index != state.selectedItem) {
      emit(state.copyWith(selectedItem: index));
    }
  }
}
