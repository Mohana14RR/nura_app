// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  final List<Message>? messages;

  MessageModel({this.messages});

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    messages: json["messages"] == null
        ? []
        : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "messages": messages == null
        ? []
        : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  final String? echoMessage;
  final int? counter;
  final int? ts;

  Message({this.echoMessage, this.counter, this.ts});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    echoMessage: json["echo_message"],
    counter: json["counter"],
    ts: json["ts"],
  );

  Map<String, dynamic> toJson() => {
    "echo_message": echoMessage,
    "counter": counter,
    "ts": ts,
  };
}
