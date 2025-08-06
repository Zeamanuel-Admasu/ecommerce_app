import 'package:equatable/equatable.dart';
import '../domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAllProductEvent extends ProductEvent {}

class GetSingleProductEvent extends ProductEvent {
  final String id;

  GetSingleProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}


class UpdateProductEvent extends ProductEvent {
  final Product product;

  UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProductEvent extends ProductEvent {
  final Product product;

  CreateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}
