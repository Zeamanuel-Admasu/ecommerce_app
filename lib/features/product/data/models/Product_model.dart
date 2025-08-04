import '../../domain/entities/product.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
  });

  // Convert from JSON to ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  // Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  // Convert ProductModel to domain Product
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      price: price,
    );
  }

  // Create ProductModel from domain Product
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
    );
  }
}
