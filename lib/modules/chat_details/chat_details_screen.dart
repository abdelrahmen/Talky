import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talky/models/message_model.dart';
import 'package:talky/models/user_model.dart';
import 'package:talky/modules/cubit/cubit.dart';
import 'package:talky/modules/cubit/states.dart';
import 'package:talky/styles/colors.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel model;
  final messageController = TextEditingController();
  ChatDetailsScreen({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var cubit = MainCubit.get(context);
      cubit.getMessages(recieverId: model.uId);
      return BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Row(
                children: [
                  CircleAvatar(),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${model.name}",
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  (cubit.messages.isEmpty)
                      ? const Expanded(
                          child: Center(
                            child: Text("Empty"),
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              if (cubit.messages[index].senderId ==
                                  FirebaseAuth.instance.currentUser?.uid) {
                                return buildMyMessage(cubit.messages[index]);
                              }
                              return buildRecieverMessage(
                                  cubit.messages[index]);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8,
                            ),
                            itemCount: cubit.messages.length,
                          ),
                        ),
                  Row(
                    children: [
                      //message form field
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Message",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //send Button
                      CircleAvatar(
                        backgroundColor: MyColors.spaceCadet,
                        radius: 27,
                        child: IconButton(
                          onPressed: () {
                            if (messageController.text != "") {
                              cubit.sendMessage(
                                text: messageController.text,
                                recieverId: model.uId,
                                dateTime: DateTime.now().toString(),
                              );
                              print("sent ${model.uId} +++++++++++");
                              print(
                                  "sent ${messageController.text} +++++++++++");
                              messageController.text = "";
                            }
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

Widget buildRecieverMessage(MessageModel message) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            bottomEnd: Radius.circular(10),
          ),
        ),
        child: SelectableText("${message.text}"),
      ),
    );

Widget buildMyMessage(MessageModel message) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: MyColors.bluePurple.shade400,
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            bottomStart: Radius.circular(10),
          ),
        ),
        child: SelectableText("${message.text}"),
      ),
    );
