import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';

// If you have CACHED_PRODUCTS_KEY defined in another file, import it.
// Otherwise, define it here:
const String CACHED_PRODUCTS_KEY = 'CACHED_PRODUCTS';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(mockPrefs);
  });

  final tProducts = [
    ProductModel(id: '1', name: 'Item 1', price: 99.9),
    ProductModel(id: '2', name: 'Item 2', price: 199.9),
  ];

  group('cacheProducts', () {
    test('should call SharedPreferences to cache the data', () async {
      // arrange
      final expectedJsonString =
          jsonEncode(tProducts.map((e) => e.toJson()).toList());

      when(mockPrefs.setString(CACHED_PRODUCTS_KEY, expectedJsonString))
          .thenAnswer((_) async => true);

      // act
      await dataSource.cacheProducts(tProducts);

      // assert
      verify(mockPrefs.setString(CACHED_PRODUCTS_KEY, expectedJsonString));
    });
  });

  group('getCachedProducts', () {
    test('should return List<ProductModel> from SharedPreferences', () async {
      // arrange
      final jsonList = jsonEncode(tProducts.map((e) => e.toJson()).toList());
      when(mockPrefs.getString(CACHED_PRODUCTS_KEY)).thenReturn(jsonList);

      // act
      final result = await dataSource.getCachedProducts();

      // assert
      expect(result, equals(tProducts));
    });

    test('should throw if no data is present', () async {
      when(mockPrefs.getString(CACHED_PRODUCTS_KEY)).thenReturn(null);

      expect(() => dataSource.getCachedProducts(), throwsA(isA<Exception>()));
    });
  });
}
