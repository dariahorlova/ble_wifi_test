import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

class InternetService {
  static const String _pingUrl =
      "https://dev-dot-calis-books-apps.uc.r.appspot.com/api/users/me/";

  Future<bool> hasInternet() async {
    try {
      final response = await http
          .get(Uri.parse(_pingUrl))
          .timeout(const Duration(seconds: 5));

      // expected result is errorcode 401.
      if (response.statusCode == 401) {
        return true;
      }
      // can't be anything else, so, something is wrong
      return false;
    } on SocketException catch (_) {
      // internet is off
      return false;
    } on TimeoutException catch (_) {
      // internet is not available
      return false;
    } catch (e) {
      // some other error. we dont care of it
      return false;
    }
  }
}
