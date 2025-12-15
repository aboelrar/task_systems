import 'package:dio/dio.dart';

import '../../../../core/error/exception.dart';
import '../model/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({required int limit});

  Future<ProductModel> getProductDetails(int id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final Dio dio;

  ProductsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts({required int limit}) async {
    try {
      final res = await dio.get('/products', queryParameters: {'limit': limit});
      final data = res.data as List;
      return ProductModel.listFromJson(data);
    } on DioException catch (e) {
      if (e.error is Exception) throw e.error as Exception;
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    try {
      final res = await dio.get('/products/$id');
      return ProductModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is Exception) throw e.error as Exception;
      throw ServerException();
    }
  }
}
