import 'package:mockito/annotations.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';

@GenerateMocks([
  ProductRemoteDataSource,
  ProductLocalDataSource,
  NetworkInfo,
])
void main() {
  // Force the type resolution by referencing the expected types:
  final _ = <ProductModel>[];
}
