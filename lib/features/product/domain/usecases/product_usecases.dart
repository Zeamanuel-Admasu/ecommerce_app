import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

class GetAllProducts {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  FutureEither<List<Product>> call() async {
    try {
      final products = await repository.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(Failure('Failed to load products: $e'));
    }
  }
}

class GetSingleProduct {
  final ProductRepository repository;

  GetSingleProduct(this.repository);

  FutureEither<Product> call(String id) async {
    try {
      final product = await repository.getProductById(id);
      return Right(product);
    } catch (e) {
      return Left(Failure('Failed to load product: $e'));
    }
  }
}

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  FutureEither<void> call(Product product) async {
    try {
      await repository.createProduct(product); // ✅ now calling
      return Right(null);
    } catch (e) {
      return Left(Failure('Failed to create product: $e'));
    }
  }
}

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  FutureEither<void> call(Product product) async {
    try {
      await repository.updateProduct(product); // ✅ now calling
      return Right(null);
    } catch (e) {
      return Left(Failure('Failed to update product: $e'));
    }
  }
}

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  FutureEither<void> call(String id) async {
    try {
      await repository.deleteProduct(id); // ✅ now calling
      return Right(null);
    } catch (e) {
      return Left(Failure('Failed to delete product: $e'));
    }
  }
}
