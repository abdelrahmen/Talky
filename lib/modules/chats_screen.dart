import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talky/models/user_model.dart';
import 'package:talky/modules/chat_details/chat_details_screen.dart';
import 'package:talky/modules/cubit/cubit.dart';
import 'package:talky/modules/cubit/states.dart';
import 'package:talky/modules/settings/settings_screen.dart';
import 'package:talky/shared/components.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              var name = snapshot.data?.displayName;
              return Scaffold(
                appBar: AppBar(
                  title: Text(name ?? "no name"),
                  actions: [
                    IconButton(
                        onPressed: () {
                          navigateTo(context, SettingsScreen());
                        },
                        icon: const Icon(Icons.settings)),
                  ],
                ),
                body: (cubit.users.isNotEmpty)
                    ? ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildChatItem(context, cubit.users[index]),
                        separatorBuilder: (context, index) => mySeparator(),
                        itemCount: cubit.users.length,
                      )
                    : const Center(
                        child: Text("Empty"),
                      ),
              );
            });
      },
    );
  }
}

Widget buildChatItem(context, UserModel model) => InkWell(
      onTap: () {
        MainCubit.get(context).getMessages(recieverId: model.uId);
        navigateTo(context, ChatDetailsScreen(model: model));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${model.name}"),
                  // Text(
                  //   "20/10/2022",
                  //   style: TextStyle(
                  //     fontSize: 10,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
