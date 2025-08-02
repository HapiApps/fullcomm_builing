import 'dart:convert';
import 'dart:developer';

import 'package:fullcomm_billing/api/api_urls.dart';

import '../data/project_data.dart';
import '../models/user_response.dart';
import 'package:http/http.dart' as http;

class CredentialsRepository {

  /// -------------- User Login ----------------
  Future<UserDataResponse> loginApi({required String mobile, required String password}) async {
    final response = await http.post(
      Uri.parse(ApiUrl.script),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "mobile": mobile,
        "password": password,
        "action": "b_login"
      }),
    );

    // log("Status Code: ${{
    //     "mobile": mobile,
    //     "password": password,
    //     "action": "b_login",
    //     "cos_id":ProjectData.cosId
    //     }}");
    log("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return UserDataResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Login Error : ${response.body}");
    }
  }

}
