import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart'; 

/// [Type] is the return type, [Params] is the input parameters
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// NoParams can be used for use cases that don’t require any input
class NoParams {}
