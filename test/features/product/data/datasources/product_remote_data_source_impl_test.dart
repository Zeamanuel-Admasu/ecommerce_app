import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = ProductRemoteDataSourceImpl(mockClient);
  });

  final tProduct = ProductModel(id: '1', name: 'Item 1', price: 99.9);
  final tProductJson = {
    'id': '1',
    'name': 'Item 1',
    'price': 99.9,
  };

  group('fetchAllProducts', () {
    test('should return List<ProductModel> when status code is 200', () async {
      // arrange
      final responseJson = jsonEncode([tProductJson]);
      final uri = Uri.parse('https://ecommerce.salmanbahasoft.com/api/products');
      when(mockClient.get(uri)).thenAnswer((_) async => http.Response(responseJson, 200));

      // act
      final result = await dataSource.fetchAllProducts();

      // assert
      expect(result, isA<List<ProductModel>>());
      expect(result.first.id, equals(tProduct.id));
    });

    test('should throw an Exception when status code is not 200', () async {
      final uri = Uri.parse('https://ecommerce.salmanbahasoft.com/api/products');
      when(mockClient.get(uri)).thenAnswer((_) async => http.Response('Error', 404));

      // assert
      expect(() => dataSource.fetchAllProducts(), throwsA(isA<Exception>()));
    });
  });

  group('fetchProductById', () {
    test('should return ProductModel when status code is 200', () async {
      // arrange
      final productId = '1';
      final uri = Uri.parse('https://ecommerce.salmanbahasoft.com/api/products/$productId');
      when(mockClient.get(uri)).thenAnswer((_) async => http.Response(jsonEncode(tProductJson), 200));

      // act
      final result = await dataSource.fetchProductById(productId);

      // assert
      expect(result, isA<ProductModel>());
      expect(result.name, equals(tProduct.name));
    });

    test('should throw an Exception when status code is not 200', () async {
      final productId = '1';
      final uri = Uri.parse('https://ecommerce.salmanbahasoft.com/api/products/$productId');
      when(mockClient.get(uri)).thenAnswer((_) async => http.Response('Error', 404));

      // assert
      expect(() => dataSource.fetchProductById(productId), throwsA(isA<Exception>()));
    });
  });
}
