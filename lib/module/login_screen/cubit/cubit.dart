import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_need_to_talk/module/login_screen/cubit/states.dart';
import 'package:we_need_to_talk/shared/components/constants.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData passSuffix = Icons.visibility_off_outlined;
  bool isInvisible = true;

  void changePasswordVisibility() {
    isInvisible = !isInvisible;
    passSuffix =
        isInvisible ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(PasswordVisibilityChangeState());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((value) {
          emit(LoginSuccessState(value.user!.uid));
          uid = value.user!.uid;
    })
        .catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }
}
