import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../repositories/products_repository.dart';

class GetFavorites extends BaseUseCase<List<int>, NoParams> {
  final ProductsRepository repository;
  GetFavorites(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(NoParams params) {
    return repository.getFavorites();
  }
}