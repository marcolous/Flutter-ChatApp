import 'package:chat_app/constants/constant.dart';

class Message {
  final String message;
  final String id;

  Message({ required this.message,  required this.id});

  factory Message.fromJson(jsonData) {
    return Message(message: jsonData[kMessage], id: jsonData[kID]);
  }
}
