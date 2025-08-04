import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import '../../../../mocks/mocks.mocks.dart';

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemote;
  late MockProductLocalDataSource mockLocal;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemote = MockProductRemoteDataSource();
    mockLocal = MockProductLocalDataSource();
    mockNetwork = MockNetworkInfo();

    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  final testModel = ProductModel(id: '1', name: 'Test Product', price: 99.99);
  final List<ProductModel> typedProductList = [testModel];
  final List<Product> expectedEntities =
      typedProductList.map((model) => model.toEntity()).toList();

  group('getAllProducts', () {
    test('should fetch from remote if connected', () async {
      // Arrange
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(mockLocal.getCachedProducts())
    .thenAnswer((_) async => typedProductList as List<ProductModel>);

      when(mockLocal.cacheProducts(typedProductList))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(mockNetwork.isConnected);
      verify(mockRemote.fetchAllProducts());
      verify(mockLocal.cacheProducts(typedProductList));
      expect(result.length, expectedEntities.length);
      expect(result.first.name, expectedEntities.first.name);
    });

    test('should fetch from local if not connected', () async {
      // Arrange
      when(mockNetwork.isConnected).thenAnswer((_) async => false);
     when(mockLocal.getCachedProducts())
    .thenAnswer((_) async => typedProductList);


      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(mockNetwork.isConnected);
      verify(mockLocal.getCachedProducts());
      expect(result.length, expectedEntities.length);
      expect(result.first.name, expectedEntities.first.name);
    });
  });
}
