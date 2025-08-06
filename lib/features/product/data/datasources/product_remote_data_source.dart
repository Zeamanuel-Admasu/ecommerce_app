import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchAllProducts();
  Future<ProductModel> fetchProductById(String id);
  Future<void> createProduct(ProductModel product);  // ✅ MATCH
  Future<void> updateProduct(ProductModel product);  // ✅ FIXED
  Future<void> deleteProduct(String id);
}
