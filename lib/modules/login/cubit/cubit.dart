import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talky/modules/login/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void login({
    required email,
    required password,
  }) async {
    try {
      emit(LoginLoadingState());
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        emit(LoginSuccessfulState());
      }).catchError((onError) {
        emit(LoginErrorState(onError.toString()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginErrorState('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginErrorState('Wrong password provided for that user.'));
      }
    }
  }

  bool isVisibile = true;
  IconData eyeIcon = Icons.visibility;
  void changePassVisibility() {
    if (isVisibile) {
      isVisibile = false;
      eyeIcon = Icons.visibility_off;
      emit(ChangePassVisibilityState());
    } else {
      isVisibile = true;
      eyeIcon = Icons.visibility;
      emit(ChangePassVisibilityState());
    }
  }
}
