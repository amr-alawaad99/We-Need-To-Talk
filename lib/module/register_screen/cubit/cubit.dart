import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_need_to_talk/model/user_model.dart';
import 'package:we_need_to_talk/module/register_screen/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_need_to_talk/shared/components/constants.dart';

class RegisterCubit extends Cubit<RegisterStates>{
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  ////////////////////////
  IconData passSuffix = Icons.visibility_off_outlined;
  bool isInvisible = true;
  void changePasswordVisibility() {
    isInvisible = !isInvisible;
    passSuffix =
    isInvisible ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(PasswordVisibilityChangeState());
  }
////////////////////////

// Register New User Authentication
  void registerUser({
    required String username,
    required String email,
    required String password,
    required String phone,
}){
    emit(RegisterUserLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
          createUser(username: username, phone: phone, uid: value.user!.uid);
          emit(RegisterUserSuccessState(value.user!.uid));
          uid = value.user!.uid;
          print("user uid is dahooo: ${value.user!.uid}");
    }).catchError((error){
      emit(RegisterUserErrorState(error.toString()));
    });
  }
////////////////////////

// // Create User Firebase Firestore Data
  Future<void> createUser({
    required String username,
    required String phone,
    required String uid,
}) async {
    UserModel userModel = UserModel(
      username: username,
      uid: uid,
      phone: phone,
      bio: 'Write your bio...',
      profilePic: 'https://img.freepik.com/free-vector/cute-duck-with-umbrella-rain-cartoon-icon-illustration_138676-2693.jpg?w=740&t=st=1674943223~exp=1674943823~hmac=d427cfe27c2dc13cdbaec26a3c3896286b85fe3dee243a76a9a3ad60ac438522',
      token: await FirebaseMessaging.instance.getToken(),
      isFriend: false,
    );
    FirebaseFirestore.instance.collection('users').doc(uid).set(userModel.toMap())
    .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error){
      emit(CreateUserErrorState(error.toString()));
    });
  }
////////////////////////



}