import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';

void main() {
  final productModel = ProductModel(id: 'p1', name: 'Laptop', price: 999.99);
  final jsonMap = {
    'id': 'p1',
    'name': 'Laptop',
    'price': 999.99,
  };

  test('fromJson should return valid ProductModel', () {
    final result = ProductModel.fromJson(jsonMap);

    expect(result.id, 'p1');
    expect(result.name, 'Laptop');
    expect(result.price, 999.99);
  });

  test('toJson should return a map with correct data', () {
    final result = productModel.toJson();

    expect(result, jsonMap);
  });

  test('toEntity should return a Product entity', () {
    final entity = productModel.toEntity();

    expect(entity, isA<Product>());
    expect(entity.id, productModel.id);
    expect(entity.name, productModel.name);
    expect(entity.price, productModel.price);
  });
}
