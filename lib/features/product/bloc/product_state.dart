import 'package:equatable/equatable.dart';
import '../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends ProductState {}

class LoadingState extends ProductState {}

class LoadedAllProductState extends ProductState {
  final List<Product> products;

  LoadedAllProductState(this.products);

  @override
  List<Object?> get props => [products];
}

class LoadedSingleProductState extends ProductState {
  final Product product;

  LoadedSingleProductState(this.product);

  @override
  List<Object?> get props => [product];
}

class ErrorState extends ProductState {
  final String message;

  ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
