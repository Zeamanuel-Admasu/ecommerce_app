import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    final response = await client.get(
      Uri.parse('https://ecommerce.salmanbahasoft.com/products'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  @override
  Future<ProductModel> fetchProductById(String id) async {
    final response = await client.get(
      Uri.parse('https://ecommerce.salmanbahasoft.com/products/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch product by ID');
    }
  }
}
