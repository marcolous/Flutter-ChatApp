import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/constant.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<Message> messagesList = [];

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageController);

  void sendMessage({required String message, required String email}) {
    messages.add({
      kMessage: message,
      kCreatedAt: DateTime.now(),
      kID: email,
    });
  }

  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messagesList: messagesList));
    });
  }
}
