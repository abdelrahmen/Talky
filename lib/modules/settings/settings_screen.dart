import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talky/modules/login/login_screen.dart';
import 'package:talky/modules/settings/cubit/cubit.dart';
import 'package:talky/modules/settings/cubit/states.dart';
import 'package:talky/shared/components.dart';
import 'package:talky/styles/colors.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingCubit(),
      child: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = SettingCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white.withOpacity(0),
              foregroundColor: MyColors.spaceCadet,
              elevation: 0,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 52,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: (state is SettingImagePickedSuccessfulState)
                                    ? FileImage(File(cubit.image?.path ?? "")) as ImageProvider
                                    :NetworkImage(
                                        "${FirebaseAuth.instance.currentUser?.photoURL}"),
                                  ),
                                ),
                                //pick new image
                                Container(
                                  width: 30,
                                  height: 30,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.blue,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      cubit.pickImage();
                                    },
                                    icon: const Icon(Icons.edit_sharp),
                                    iconSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //name form field
                        const Text('Name'),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText:
                                "${FirebaseAuth.instance.currentUser?.displayName}",
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //email form field
                        const Text('Email'),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText:
                                "${FirebaseAuth.instance.currentUser?.email}",
                          ),
                          validator: (value) {
                            bool emailValid = false;
                            if (value != null) {
                              emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);
                            }
                            return emailValid ? null : "enter a valid email";
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //password form field
                        const Text('Password'),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null) {
                              if (value.length < 6) {
                                return "Password Cannot be Less Than 6 Characters";
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            //update user data, save button
                            ElevatedButton(
                                onPressed: () {
                                  cubit.update(
                                    newName: nameController.text,
                                    newEmail: emailController.text,
                                    newPassword: passwordController.text,
                                    context: context,
                                  );
                                },
                                child: const Text("Save")),
                            const Spacer(),
                            //signout button
                            TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut().then((value) {
                                  navigateWithNoBack(context, LoginScreen());
                                });
                              },
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
