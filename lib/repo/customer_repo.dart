import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fullcomm_billing/api/api_urls.dart';
import 'package:fullcomm_billing/data/local_data.dart';
import 'package:fullcomm_billing/models/common_response.dart';
import 'package:fullcomm_billing/models/customers_response.dart';

import '../data/project_data.dart';

class CustomersRepository {
  /// ----------- Get Customer List ---------------
  Future<CustomersResponse> getCustomers() async {
    final body = jsonEncode({
      'action': 'b_select_customers', // Fix
      "cos_id":localData.cosId
    });
    try {
      final response = await http.post(Uri.parse(ApiUrl.script),body: body);
      return CustomersResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception("getCustomers Error : $e");
    }
  }

  /// ------------ Add Customer ---------------
  Future<CommonResponse> addCustomer({
    required String name,
    required String mobile,
    required String addressLine1,
    required String area,
    required String pincode,
    required String city,
    required String state,
  }) async {
    final body = jsonEncode({
      "name": name,
      "mobile": mobile,
      "platform": LocalData.platformKey,
      "created_by": localData.userName,
      "address_line_1": addressLine1,
      "area": area,
      "cos_id":localData.cosId,
      'pincode': pincode,
      'city': city,
      'state': state,
      'country': 'India',
      'action': 'b_add_customer', /// Fix
    });

    try {
      final response = await http.post(
          Uri.parse(ApiUrl.script),
          body: body
      );

      return CommonResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception("addCustomer Error : $e");
    }
  }

}
