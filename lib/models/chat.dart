import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class ChatModel extends ChangeNotifier {
  late bool _pinned;
  late int _unreadCount;

  bool get pinned => _pinned;
  void pin() {
    _pinned = !_pinned;
    notifyListeners();
  }
    void get unreadCount => _unreadCount;
    void unreadAdd(int news) {
      _unreadCount += news;
      notifyListeners();
    }
}
