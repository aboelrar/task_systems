import 'package:dartz/dartz.dart';
import 'package:systems_task/core/usecase/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProductDetails extends BaseUseCase<Product, IdParams> {
  final ProductsRepository repository;

  GetProductDetails(this.repository);

  @override
  Future<Either<Failure, Product>> call(IdParams params) {
    return repository.getProductDetails(params.id);
  }
}
