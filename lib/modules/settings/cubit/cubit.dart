import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talky/modules/settings/cubit/states.dart';
import 'package:talky/shared/components.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial());

  static SettingCubit get(context) => BlocProvider.of(context);

  XFile? image;
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      image = value;
      emit(SettingImagePickedSuccessfulState());
    });
  }

  //we need to add the new data o firebase also
  void update({
    var newName,
    var newEmail,
    var newPassword,
    required context,
  }) async {
    var message = "";
    if (newName != "") {
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(newName)
          .then((value) {
        message += "name updated";
      });
    }
    if (newEmail != "") {
      await FirebaseAuth.instance.currentUser
          ?.updateEmail(newEmail)
          .then((value) {
        message += "email updated";
      });
    }
    if (newPassword != "") {
      await FirebaseAuth.instance.currentUser
          ?.updatePassword(newPassword)
          .then((value) {
        message += "password updated";
      });
    }
    if (image != null) {
      addToFireBaseStorageAndUpdate(context);
      image = null;
    }
    if (message != "") {
      showSnackBar(context, "info Updated");
    }
  }

  void addToFireBaseStorageAndUpdate(context) {
    final storageRef = FirebaseStorage.instance.ref();
    storageRef
        .child("users/${Uri.file(image?.path ?? '').pathSegments.last}")
        .putFile(File(image?.path ?? ""))
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        updateProfileImageLink(value);
        showSnackBar(context, "image updated successfully");
      });
    });
  }

  void updateProfileImageLink(String newProfileImageUrl) {
    FirebaseAuth.instance.currentUser?.updatePhotoURL(newProfileImageUrl);
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      "imageUrl": newProfileImageUrl,
    }, SetOptions(merge: true));
    emit(SettingImageUpdatedSuccessfulState());
  }
}
