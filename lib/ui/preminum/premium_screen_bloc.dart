import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PremiumScreenBloc extends Cubit<int> {

  PremiumScreenBloc() : super(0);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Key inputKey = GlobalKey();
  BuildContext? textFieldContext;

  void updateSelectedIndex(index) {
    if (index != state) {
      emit(index);
    }
  }
}
