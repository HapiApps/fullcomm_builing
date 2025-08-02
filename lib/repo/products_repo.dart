import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/api_urls.dart';
import '../data/local_data.dart';
import '../models/products_response.dart';


class ProductsRepository{

  /// Get All Products and Stock
  Future<ProductsResponse> getProducts() async {
    try {
      final Map<String, dynamic> requestBody = {
        "action": "b_select_products",
        "cos_id":localData.cosId
      };

      final response = await http.post(
        Uri.parse(ApiUrl.script),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );


      if (response.statusCode == 200) {
        return ProductsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("getProducts Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("getProducts Error: $e");
    }
  }

  }



