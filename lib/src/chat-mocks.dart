import 'package:flutter/material.dart';

class ChatData {
  String name;
  String lastMessage;
  Color color;
  int messageCount;
  bool pinned;

  ChatData({
    required this.name,
    required this.lastMessage,
    required this.color,
    required this.messageCount,
    required this.pinned,
  });
}

final chatMocks = [
  ChatData(
    color: Colors.pink[200]!,
    name: "Виталий",
    lastMessage: "Унтерсанчизес",
    messageCount: 228,
    pinned: true,
  ),
  ChatData(
    color: Colors.purple[200]!,
    name: "Abdulla",
    lastMessage: "Alhamdulillah",
    messageCount: 42,
    pinned: false,
  )
];