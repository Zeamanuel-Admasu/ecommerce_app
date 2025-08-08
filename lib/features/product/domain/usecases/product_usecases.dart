import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetAllProducts(this.repository);

 @override
Future<Either<Failure, List<Product>>> call(NoParams params) async {
  try {
    final products = await repository.getAllProducts();
    return Right(products); // ✅ wrap result in Right
  } catch (e) {
    return Left(ServerFailure('Failed to load products: $e'));
  }
}

}

class GetSingleProduct implements UseCase<Product, GetSingleProductParams> {
  final ProductRepository repository;

  GetSingleProduct(this.repository);

  @override
Future<Either<Failure, Product>> call(GetSingleProductParams params) async {
  try {
    final product = await repository.getProductById(params.id);
    return Right(product);
  } catch (e) {
    return Left(ServerFailure('Failed to load product: $e'));
  }
}

}

class CreateProduct implements UseCase<void, CreateProductParams> {
  final ProductRepository repository;

  CreateProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateProductParams params) async {
    await repository.createProduct(params.product);
    return const Right(null);
  }
}

class UpdateProduct implements UseCase<void, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) async {
    await repository.updateProduct(params.product);
    return const Right(null);
  }
}

class DeleteProduct implements UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) async {
    await repository.deleteProduct(params.id);
    return const Right(null);
  }
}

class GetSingleProductParams {
  final String id;

  GetSingleProductParams(this.id);
}

class CreateProductParams {
  final Product product;

  CreateProductParams(this.product);
}

class UpdateProductParams {
  final Product product;

  UpdateProductParams(this.product);
}

class DeleteProductParams {
  final String id;

  DeleteProductParams(this.id);
}
