import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talky/modules/settings/cubit/states.dart';
import 'package:talky/shared/components.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial());

  static SettingCubit get(context) => BlocProvider.of(context);

  void update({
    var newName,
    var newEmail,
    var newPassword,
    required context,
  }) async {
    var message = "";
    if (newName != "") {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(newName).then((value) {
        message += "name updated";
      });
    }
    if (newEmail != "") {
      await FirebaseAuth.instance.currentUser?.updateEmail(newEmail).then((value) {
        message += "email updated";
      });
    }
    if (newPassword != "") {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword).then((value) {
        message += "password updated";
      });
    }
    if (message != "") {
      showSnackBar(context, "info Updated");
    }
  }
}
