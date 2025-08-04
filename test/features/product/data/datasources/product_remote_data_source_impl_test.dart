import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'product_remote_data_source_impl_test.mocks.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source_impl.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  const baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1';

  final tProduct = ProductModel(id: '1', name: 'Item 1', price: 99.9);
  final tProductJson = {
    'id': '1',
    'name': 'Item 1',
    'price': 99.9,
  };

  setUp(() {
    // registerFallbackValue(Uri());
    mockClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(mockClient);
  });

  group('fetchAllProducts', () {
    test('should return List<ProductModel> when status code is 200', () async {
      final responseJson = jsonEncode([tProductJson]);
      final uri = Uri.parse('$baseUrl/products');

      when(mockClient.get(uri, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(responseJson, 200));

      final result = await dataSource.fetchAllProducts();

      expect(result, isA<List<ProductModel>>());
      expect(result.first.id, equals(tProduct.id));
    });

    test('should throw Exception when status code is not 200', () async {
      final uri = Uri.parse('$baseUrl/products');

      when(mockClient.get(uri, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 404));

      expect(() => dataSource.fetchAllProducts(), throwsA(isA<Exception>()));
    });
  });

  group('fetchProductById', () {
    test('should return ProductModel when status code is 200', () async {
      final productId = '1';
      final uri = Uri.parse('$baseUrl/products/$productId');

      when(mockClient.get(uri, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode(tProductJson), 200));

      final result = await dataSource.fetchProductById(productId);

      expect(result, isA<ProductModel>());
      expect(result.name, equals(tProduct.name));
    });

    test('should throw Exception when status code is not 200', () async {
      final productId = '1';
      final uri = Uri.parse('$baseUrl/products/$productId');

      when(mockClient.get(uri, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 404));

      expect(() => dataSource.fetchProductById(productId), throwsA(isA<Exception>()));
    });
  });
}
