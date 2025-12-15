import 'package:dartz/dartz.dart';
import 'package:systems_task/core/usecase/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProducts extends BaseUseCase<List<Product>, GetProductsParams> {
  final ProductsRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) {
    return repository.getProducts(limit: params.limit);
  }
}

class GetProductsParams {
  final int limit;

  const GetProductsParams(this.limit);
}
