import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

const CACHED_PRODUCTS_KEY = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final productJsonList =
        products.map((product) => product.toJson()).toList();
    final jsonString = jsonEncode(productJsonList);
    await sharedPreferences.setString(CACHED_PRODUCTS_KEY, jsonString);
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS_KEY);

    if (jsonString != null) {
      final List<dynamic> decodedList = jsonDecode(jsonString);
      return decodedList
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception('No cached products found');
    }
  }
}
