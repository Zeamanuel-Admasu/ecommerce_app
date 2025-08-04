// lib/features/product/data/repositories/product_repository_impl.dart
import 'package:ecommerce_app/core/network/network_info.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/product_local_data_source.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
Future<List<Product>> getAllProducts() async {
  if (await networkInfo.isConnected) {
    try {
      final remoteProducts = await remoteDataSource.fetchAllProducts();
      await localDataSource.cacheProducts(remoteProducts);
      // 🔁 Map ProductModel → Product
      return remoteProducts.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Failed to fetch from remote: $e");
    }
  } else {
    try {
      final cachedProducts = await localDataSource.getCachedProducts();
      // 🔁 Map ProductModel → Product
      return cachedProducts.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("No internet and failed to load from cache: $e");
    }
  }
}

@override
Future<Product> getProductById(String id) async {
  if (await networkInfo.isConnected) {
    try {
      final productModel = await remoteDataSource.fetchProductById(id);
      return productModel.toEntity();
    } catch (e) {
      throw Exception("Failed to fetch product by ID: $e");
    }
  } else {
    throw Exception("No internet connection. Cannot fetch product by ID.");
  }
}
}