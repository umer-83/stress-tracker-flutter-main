import 'package:flutter/foundation.dart';

class UserIdProvider with ChangeNotifier {
  String? userId;
  String? employeeId;

  void setUserId(String? id) {
    userId = id;
    notifyListeners();
  }

  void setEmployeeId(String? id) {
    employeeId = id;
    notifyListeners();
  }
}
