import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:systems_task/core/error/exception.dart';
import 'package:systems_task/features/products/data/data_source/products_remote_data_source_impl.dart';
import 'package:systems_task/features/products/data/model/product_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ProductsRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = ProductsRemoteDataSourceImpl(mockDio);
  });

  group('getProducts', () {
    test('should return list of ProductModel when API call is successful', () async {
      // Arrange
      const limit = 10;
      final mockResponse = Response(
        data: [
          {
            'id': 1,
            'title': 'Test Product',
            'price': 99.99,
            'description': 'Test description',
            'image': 'https://test.com/image.jpg',
            'category': 'electronics',
          },
          {
            'id': 2,
            'title': 'Test Product 2',
            'price': 199.99,
            'description': 'Test description 2',
            'image': 'https://test.com/image2.jpg',
            'category': 'clothing',
          },
        ],
        statusCode: 200,
        requestOptions: RequestOptions(path: '/products'),
      );

      when(() => mockDio.get(
            '/products',
            queryParameters: {'limit': limit},
          )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getProducts(limit: limit);

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, equals(2));
      expect(result[0].id, equals(1));
      expect(result[0].title, equals('Test Product'));
      expect(result[0].price, equals(99.99));
      expect(result[1].id, equals(2));
      verify(() => mockDio.get(
            '/products',
            queryParameters: {'limit': limit},
          )).called(1);
    });

    test('should call API with correct limit parameter', () async {
      const limit = 20;
      final mockResponse = Response(
        data: [],
        statusCode: 200,
        requestOptions: RequestOptions(path: '/products'),
      );

      when(() => mockDio.get(
            '/products',
            queryParameters: {'limit': limit},
          )).thenAnswer((_) async => mockResponse);

      // Act
      await dataSource.getProducts(limit: limit);

      // Assert
      verify(() => mockDio.get(
            '/products',
            queryParameters: {'limit': limit},
          )).called(1);
    });

    test('should throw ServerException when DioException occurs', () async {
      // Arrange
      const limit = 10;
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/products'),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: '/products'),
        ),
      );

      when(() => mockDio.get(
            '/products',
            queryParameters: {'limit': limit},
          )).thenThrow(dioException);

      // Act & Assert
      expect(
        () => dataSource.getProducts(limit: limit),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw custom Exception when DioException has error as Exception', () async {
      // Arrange
      const limit = 10;
      final customException = Exception('Custom error');
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/products'),
        error: customException,
      );

      when(() => mockDio.get(
            '/products',
            queryParameters: {'limit': limit},
          )).thenThrow(dioException);

      // Act & Assert
      expect(
        () => dataSource.getProducts(limit: limit),
        throwsA(equals(customException)),
      );
    });
  });
}

