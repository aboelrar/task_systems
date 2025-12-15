import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getProducts({required int limit});

  Future<Either<Failure, Product>> getProductDetails(int id);

  Future<Either<Failure, bool>> toggleFavorite(int productId);

  Future<Either<Failure, List<int>>> getFavorites();

  Future<Either<Failure, bool>> isFavorite(int productId);
}
