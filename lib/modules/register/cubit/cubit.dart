import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talky/modules/register/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  var db = FirebaseFirestore.instance;

  void addDataToFireBase({
    required name,
    required email,
    required uId,
    required imageUrl,
  }) async {
    db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).set({
      "name": name,
      "email": email,
      "uId": uId,
      "image": imageUrl,
    });
  }

  void register({
    required email,
    required password,
    required name,
  }) async {
    try {
      emit(RegisterLoadingState());
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        final user = FirebaseAuth.instance.currentUser;
        await user?.updateDisplayName(name);
        await user?.updatePhotoURL(
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png");
        addDataToFireBase(
          name: name,
          email: email,
          uId: user?.uid,
          imageUrl: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png",
        );
        emit(RegisterSuccessfulState());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterErrorState('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterErrorState('an account already exists for that email.'));
      }
    } catch (e) {
      print(e);
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
