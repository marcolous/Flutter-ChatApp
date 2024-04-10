// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_constructors_in_immutables, use_build_context_synchronously, unnecessary_import, must_be_immutable
import 'package:chat_app/cubits/chat/chat_cubit.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.email});

  final String? email;
  final _controller = ScrollController();
  //List<Message> messagesList = [];
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        'assets/images/bg.jpg',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  var messagesList =
                      BlocProvider.of<ChatCubit>(context).messagesList;
                  return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? getSenderView(
                              ChatBubbleClipper5(type: BubbleType.sendBubble),
                              context,
                              messagesList[index])
                          : getReceiverView(
                              ChatBubbleClipper5(
                                  type: BubbleType.receiverBubble),
                              context,
                              messagesList[index]);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  hintText: 'Send Message',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send_rounded, color: Colors.black),
                    onPressed: () {
                      String data = controller.text;
                      if (data.isNotEmpty) {
                        BlocProvider.of<ChatCubit>(context)
                            .sendMessage(message: data, email: email!);
                        controller.clear();
                        _controller.jumpTo(0);
                      }
                    },
                  ),
                ),
                controller: controller,
                onSubmitted: (data) {
                  BlocProvider.of<ChatCubit>(context)
                      .sendMessage(message: data, email: email!);

                  controller.clear();
                  _controller.jumpTo(0);
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

getSenderView(CustomClipper clipper, BuildContext context, Message message) =>
    ChatBubble(
      clipper: clipper,
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 5),
      backGroundColor: Colors.blue,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Text(
          message.message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

getReceiverView(CustomClipper clipper, BuildContext context, Message message) =>
    ChatBubble(
      clipper: clipper,
      backGroundColor: Color(0xffE7E7ED),
      margin: EdgeInsets.only(top: 5),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message.message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );



// builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               List<Message> messagesList = [];
//               for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                 messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
//               }
//               return