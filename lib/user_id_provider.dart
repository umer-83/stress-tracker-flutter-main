import 'package:flutter/foundation.dart';

class UserIdProvider with ChangeNotifier {
  String? userId;

  void setUserId(String? id) {
    userId = id;
    notifyListeners();
  }
}
