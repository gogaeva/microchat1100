import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class ChatModel extends ChangeNotifier {
  ChatModel({required this.pinned, required this.unreadCount});
  bool pinned;
  int unreadCount;

  void pin() {
    pinned = !pinned;
    notifyListeners();
  }

  void unreadAdd(int news) {
    unreadCount += news;
    notifyListeners();
  }
}
