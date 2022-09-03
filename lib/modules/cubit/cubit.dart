import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talky/models/message_model.dart';
import 'package:talky/models/user_model.dart';
import 'package:talky/modules/cubit/states.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitialState());

  // var user = FirebaseAuth.instance.currentUser;
  // void refreshUser(){
  //   user = FirebaseAuth.instance.currentUser;
  // }
  static MainCubit get(context) => BlocProvider.of(context);

  var db = FirebaseFirestore.instance;

  List<UserModel> users = [];
  void getAllUsers() async {
    users = [];
    emit(MainGetAllUsersLoadingState());
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        if (doc.data()["uId"] == FirebaseAuth.instance.currentUser?.uid) {
          continue;
        }
        users.add(UserModel.fromJson(doc.data()));
      }
      emit(MainGetAllUsersSuccessfulState());
    }).catchError((onError) {
      emit(MainGetAllUsersErrorState());
    });
  }

  void sendMessage({
    required String text,
    required String? recieverId,
    required String dateTime,
  }) {
    //sender
    db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("chats")
        .doc(recieverId)
        .collection("messages")
        .add({
      "text": text,
      "recieverId": recieverId,
      "senderId": FirebaseAuth.instance.currentUser?.uid,
      "dateTime": dateTime,
    }).then((value) {
      emit(MainSendMessageSuccessfulState());
    }).catchError((onError) {
      emit(MainSendMessageErrorState());
    });
    //reciever
    db
        .collection("users")
        .doc(recieverId)
        .collection("chats")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("messages")
        .add({
      "text": text,
      "recieverId": recieverId,
      "senderId": FirebaseAuth.instance.currentUser?.uid,
      "dateTime": dateTime,
    }).then((value) {
      emit(MainSendMessageSuccessfulState());
    }).catchError((onError) {
      emit(MainSendMessageErrorState());
    });
  }

  late List<MessageModel> messages = [];
  void getMessages({
    required String? recieverId,
  }) async{
    emit(MainGetMessageLoadingState());
    db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("chats")
        .doc(recieverId)
        .collection("messages")
        .orderBy("dateTime")
        .snapshots()
        .listen((event) {
      messages = [];
      for (var doc in event.docs) {
        messages.add(MessageModel.fromJson(doc.data()));
        emit(MainGetMessageSuccessfulState());
      }
    });
    emit(MainGetMessageSuccessfulState());
  }

  void refreshUsers()=>emit(MainRefreshUsersListState());
}
