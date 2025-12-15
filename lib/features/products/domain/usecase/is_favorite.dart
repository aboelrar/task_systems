import 'package:dartz/dartz.dart';
import 'package:systems_task/core/usecase/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../repositories/products_repository.dart';

class IsFavorite extends BaseUseCase<bool, IdParams> {
  final ProductsRepository repository;

  IsFavorite(this.repository);

  @override
  Future<Either<Failure, bool>> call(IdParams params) {
    return repository.isFavorite(params.id);
  }
}
