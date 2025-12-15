import 'package:dartz/dartz.dart';

import '../error/failure.dart';

abstract class BaseUseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {}

class IdParams {
  final int id;

  IdParams(this.id);
}
