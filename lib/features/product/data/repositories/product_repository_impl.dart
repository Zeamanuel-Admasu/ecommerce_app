import 'package:ecommerce_app/core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart'; // ✅ only this one

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
        return remoteProducts.map((model) => model.toEntity()).toList();
      } catch (e) {
        throw Exception("Failed to fetch from remote: $e");
      }
    } else {
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
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

  @override
  Future<void> createProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final model = ProductModel.fromEntity(product);
        await remoteDataSource.createProduct(model); // ✅ fixed
      } catch (e) {
        throw Exception("Failed to create product: $e");
      }
    } else {
      throw Exception("No internet connection. Cannot create product.");
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final model = ProductModel.fromEntity(product);
        await remoteDataSource.updateProduct(model); // ✅ fixed
      } catch (e) {
        throw Exception("Failed to update product: $e");
      }
    } else {
      throw Exception("No internet connection. Cannot update product.");
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProduct(id);
      } catch (e) {
        throw Exception("Failed to delete product: $e");
      }
    } else {
      throw Exception("No internet connection. Cannot delete product.");
    }
  }
}
