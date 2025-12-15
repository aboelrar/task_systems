import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../data_source/products_local_data_source.dart';
import '../data_source/products_remote_data_source_impl.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remote;
  final ProductsLocalDataSource local;
  final NetworkInfo networkInfo;

  ProductsRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    required int limit,
  }) async {
    try {
      final products = await remote.getProducts(limit: limit);
      await local.cacheProducts(products);
      return Right(products);
    } on NetworkException {
      try {
        final cached = await local.getCachedProducts();
        return Right(cached);
      } on CacheException {
        return const Left(NetworkFailure('No internet and no cached data'));
      } catch (_) {
        return const Left(CacheFailure('Cache error'));
      }
    } on ServerException {
      return const Left(ServerFailure('Server error'));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetails(int id) async {
    try {
      final product = await remote.getProductDetails(id);
      await local.cacheProduct(product);
      return Right(product);
    } on NetworkException {
      final cached = await local.getCachedProduct(id);
      if (cached != null) return Right(cached);
      return const Left(NetworkFailure('No internet and no cached details'));
    } on ServerException {
      final cached = await local.getCachedProduct(id);
      if (cached != null) return Right(cached);
      return const Left(ServerFailure('Server error'));
    } catch (_) {
      final cached = await local.getCachedProduct(id);
      if (cached != null) return Right(cached);
      return const Left(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(int productId) async {
    try {
      final newState = await local.toggleFavorite(productId);
      return Right(newState);
    } catch (_) {
      return const Left(CacheFailure('Favorites storage error'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getFavorites() async {
    try {
      final ids = await local.getFavorites();
      return Right(ids);
    } catch (_) {
      return const Left(CacheFailure('Favorites read error'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int productId) async {
    try {
      final v = await local.isFavorite(productId);
      return Right(v);
    } catch (_) {
      return const Left(CacheFailure('Favorites read error'));
    }
  }
}
