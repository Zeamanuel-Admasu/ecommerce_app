import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../../../../core/network/network_info.dart';

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
      final remoteProducts = await remoteDataSource.fetchAllProducts();
      await localDataSource.cacheProducts(remoteProducts);
      return remoteProducts.map((model) => model.toEntity()).toList();
    } else {
      final localProducts = await localDataSource.getCachedProducts();
      return localProducts.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      final model = await remoteDataSource.fetchProductById(id);
      return model.toEntity();
    } else {
      final cached = await localDataSource.getCachedProducts();
      final found = cached.firstWhere((p) => p.id == id);
      return found.toEntity();
    }
  }
}
