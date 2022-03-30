import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  String get userId {
    return _userId!;
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDWfHg7xgL7TTloVOW9V8sy_gbq7enbqKQ');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    // ignore: unused_local_variable
    final extractedUserdata = json
        .decode(prefs.getString('userData') as dynamic) as Map<String, Object>;
    final expiryDate =
        DateTime.parse(extractedUserdata['expiryDate'] as dynamic);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserdata['token'] as dynamic;
    _userId = extractedUserdata['userId'] as dynamic;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    print(_token);
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry!), logout);
  }
}

// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:shop_app/models/http_exception.dart';
// import 'package:shop_app/screens/product_detail_screen.dart';
//
// class Auth with ChangeNotifier {
//   String? _token;
//   DateTime? _expiryDate;
//   String? _userId;
//
//   bool get isAuth {
//     return token != null;
//   }
//
//   String? get token {
//     if (_expiryDate != null &&
//         _expiryDate!.isAfter(DateTime.now()) &&
//         _token != null) {
//       return _token;
//     }
//     return null;
//   }
//
//   Future<void> _authenticate(
//       String email, String password, String urlSegment) async {
//     final url = Uri.parse(
//         'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDiu81zM3Rufm04tCYETDhZmwqmIzqo_qA');
//     try {
//       final response = await http.post(url,
//           body: json.encode({
//             'email': email,
//             'password': password,
//             'returnSecureToken': true
//           }));
//       final responseData = json.decode(response.body);
//       print(responseData);
//       if (responseData['error'] != null) {
//         throw HttpException(responseData['error']['message']);
//       }
//       _token = responseData['idToken'];
//       _userId = responseData['localId'];
//       _expiryDate =
//           DateTime.now().add(Duration(seconds: int.parse('expressIn')));
//       notifyListeners();
//     } catch (error) {
//       throw error;
//     }
//
//     // print(json.decode(response.body));
//   }
//
//   Future<void> signUp(String email, String password) async {
//     return _authenticate(email, password, 'signUp');
//   }
//
//   Future<void> logIn(String email, String password) async {
//     return _authenticate(email, password, 'signInWithPassword');
//   }
// }
