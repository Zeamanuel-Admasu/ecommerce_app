import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    final response = await client.get(
      Uri.parse(baseUrl),
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
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch product by ID');
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
