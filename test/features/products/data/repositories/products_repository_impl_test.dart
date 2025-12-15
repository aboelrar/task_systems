import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:systems_task/core/error/exception.dart';
import 'package:systems_task/core/error/failure.dart';
import 'package:systems_task/core/network/network_info.dart';
import 'package:systems_task/features/products/data/data_source/products_local_data_source.dart';
import 'package:systems_task/features/products/data/data_source/products_remote_data_source_impl.dart';
import 'package:systems_task/features/products/data/model/product_model.dart';
import 'package:systems_task/features/products/data/repositories/products_repository_impl.dart';
import 'package:systems_task/features/products/domain/entities/product.dart';

class MockProductsRemoteDataSource extends Mock implements ProductsRemoteDataSource {}

class MockProductsLocalDataSource extends Mock implements ProductsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductsRepositoryImpl repository;
  late MockProductsRemoteDataSource mockRemoteDataSource;
  late MockProductsLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductsRemoteDataSource();
    mockLocalDataSource = MockProductsLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductsRepositoryImpl(
      remote: mockRemoteDataSource,
      local: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tProductModels = [
    const ProductModel(
      id: 1,
      title: 'Test Product 1',
      price: 99.99,
      description: 'Test description 1',
      image: 'https://test.com/image1.jpg',
      category: 'electronics',
    ),
    const ProductModel(
      id: 2,
      title: 'Test Product 2',
      price: 199.99,
      description: 'Test description 2',
      image: 'https://test.com/image2.jpg',
      category: 'clothing',
    ),
  ];

  group('getProducts', () {
    test('should return Right with products list when remote call is successful', () async {
      // Arrange
      const limit = 10;
      when(() => mockRemoteDataSource.getProducts(limit: limit))
          .thenAnswer((_) async => tProductModels);
      when(() => mockLocalDataSource.cacheProducts(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getProducts(limit: limit);

      // Assert
      expect(result, isA<Right<Failure, List<Product>>>());
      result.fold(
        (failure) => fail('should not return failure'),
        (products) {
          expect(products.length, equals(2));
          expect(products[0].id, equals(1));
          expect(products[1].id, equals(2));
        },
      );
      verify(() => mockRemoteDataSource.getProducts(limit: limit)).called(1);
      verify(() => mockLocalDataSource.cacheProducts(tProductModels)).called(1);
    });

    test('should cache products when remote call is successful', () async {
      // Arrange
      const limit = 10;
      when(() => mockRemoteDataSource.getProducts(limit: limit))
          .thenAnswer((_) async => tProductModels);
      when(() => mockLocalDataSource.cacheProducts(any()))
          .thenAnswer((_) async => {});

      // Act
      await repository.getProducts(limit: limit);

      // Assert
      verify(() => mockLocalDataSource.cacheProducts(tProductModels)).called(1);
    });

    test('should return cached products when NetworkException occurs and cache exists', () async {
      // Arrange
      const limit = 10;
      when(() => mockRemoteDataSource.getProducts(limit: limit))
          .thenThrow(NetworkException());
      when(() => mockLocalDataSource.getCachedProducts())
          .thenAnswer((_) async => tProductModels);

      // Act
      final result = await repository.getProducts(limit: limit);

      // Assert
      expect(result, isA<Right<Failure, List<Product>>>());
      result.fold(
        (failure) => fail('should not return failure'),
        (products) {
          expect(products.length, equals(2));
        },
      );
      verify(() => mockRemoteDataSource.getProducts(limit: limit)).called(1);
      verify(() => mockLocalDataSource.getCachedProducts()).called(1);
      verifyNever(() => mockLocalDataSource.cacheProducts(any()));
    });

    test('should return NetworkFailure when NetworkException occurs and cache is empty', () async {
      // Arrange
      const limit = 10;
      when(() => mockRemoteDataSource.getProducts(limit: limit))
          .thenThrow(NetworkException());
      when(() => mockLocalDataSource.getCachedProducts())
          .thenThrow(CacheException());

      // Act
      final result = await repository.getProducts(limit: limit);

      // Assert
      expect(result, isA<Left<Failure, List<Product>>>());
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, equals('No internet and no cached data'));
        },
        (_) => fail('should return failure'),
      );
    });

    test('should return ServerFailure when ServerException occurs', () async {
      // Arrange
      const limit = 10;
      when(() => mockRemoteDataSource.getProducts(limit: limit))
          .thenThrow(ServerException());

      // Act
      final result = await repository.getProducts(limit: limit);

      // Assert
      expect(result, isA<Left<Failure, List<Product>>>());
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, equals('Server error'));
        },
        (_) => fail('should return failure'),
      );
      verifyNever(() => mockLocalDataSource.getCachedProducts());
    });

    test('should handle different limit values correctly', () async {
      // Arrange
      const limit1 = 5;
      const limit2 = 20;
      when(() => mockRemoteDataSource.getProducts(limit: limit1))
          .thenAnswer((_) async => tProductModels);
      when(() => mockRemoteDataSource.getProducts(limit: limit2))
          .thenAnswer((_) async => tProductModels);
      when(() => mockLocalDataSource.cacheProducts(any()))
          .thenAnswer((_) async => {});

      // Act
      await repository.getProducts(limit: limit1);
      await repository.getProducts(limit: limit2);

      // Assert
      verify(() => mockRemoteDataSource.getProducts(limit: limit1)).called(1);
      verify(() => mockRemoteDataSource.getProducts(limit: limit2)).called(1);
    });
  });
}

