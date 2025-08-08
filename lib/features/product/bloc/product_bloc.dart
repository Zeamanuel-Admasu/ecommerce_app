import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../domain/usecases/product_usecases.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  final GetSingleProduct getSingleProduct;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductBloc({
    required this.getAllProducts,
    required this.getSingleProduct,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(InitialState()) {
    on<LoadAllProductEvent>((event, emit) async {
      emit(LoadingState());
      final result = await getAllProducts(NoParams()); // ✅ use NoParams
      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (products) => emit(LoadedAllProductState(products)),
      );
    });

    on<GetSingleProductEvent>((event, emit) async {
      emit(LoadingState());
      final result = await getSingleProduct(GetSingleProductParams(event.id)); // ✅ use params
      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (product) => emit(LoadedSingleProductState(product)),
      );
    });

    on<CreateProductEvent>((event, emit) async {
      emit(LoadingState());
      final result = await createProduct(CreateProductParams(event.product)); // ✅ use params
      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (_) => add(LoadAllProductEvent()),
      );
    });

    on<UpdateProductEvent>((event, emit) async {
      emit(LoadingState());
      final result = await updateProduct(UpdateProductParams(event.product)); // ✅ use params
      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (_) => add(LoadAllProductEvent()),
      );
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(LoadingState());
      final result = await deleteProduct(DeleteProductParams(event.id)); // ✅ use params
      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (_) => add(LoadAllProductEvent()),
      );
    });
  }
}
