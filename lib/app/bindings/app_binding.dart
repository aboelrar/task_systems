import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../core/widgets/app_state_handler/controller/app_state_handler_controller.dart';
import '../../features/products/data/data_source/products_local_data_source.dart';
import '../../features/products/data/data_source/products_remote_data_source_impl.dart';
import '../../features/products/data/repositories/products_repository_impl.dart';
import '../../features/products/domain/repositories/products_repository.dart';
import '../../features/products/domain/usecase/get_favorites.dart';
import '../../features/products/domain/usecase/get_product_details.dart';
import '../../features/products/domain/usecase/get_products.dart';
import '../../features/products/domain/usecase/is_favorite.dart';
import '../../features/products/domain/usecase/toggle_favorite.dart';
import '../../features/products/presentation/controller/product_details_controller.dart';
import '../../features/products/presentation/controller/products_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Dio>(DioClient.create(), permanent: true);
    Get.put<Connectivity>(Connectivity(), permanent: true);

    Get.put<NetworkInfo>(
      NetworkInfoImpl(Get.find<Connectivity>()),
      permanent: true,
    );

    Get.put<Box>(
      Hive.box('products_box'),
      tag: 'products_box',
      permanent: true,
    );
    Get.put<Box>(
      Hive.box('favorites_box'),
      tag: 'favorites_box',
      permanent: true,
    );

    Get.put<ProductsRemoteDataSource>(
      ProductsRemoteDataSourceImpl(Get.find<Dio>()),
      permanent: true,
    );

    Get.put<ProductsLocalDataSource>(
      ProductsLocalDataSourceImpl(
        productsBox: Get.find<Box>(tag: 'products_box'),
        favoritesBox: Get.find<Box>(tag: 'favorites_box'),
      ),
      permanent: true,
    );

    Get.put<ProductsRepository>(
      ProductsRepositoryImpl(
        remote: Get.find<ProductsRemoteDataSource>(),
        local: Get.find<ProductsLocalDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      permanent: true,
    );

    Get.put<GetProducts>(
      GetProducts(Get.find<ProductsRepository>()),
      permanent: true,
    );
    Get.put<GetProductDetails>(
      GetProductDetails(Get.find<ProductsRepository>()),
      permanent: true,
    );
    Get.put<ToggleFavorite>(
      ToggleFavorite(Get.find<ProductsRepository>()),
      permanent: true,
    );
    Get.put<GetFavorites>(
      GetFavorites(Get.find<ProductsRepository>()),
      permanent: true,
    );
    Get.put<IsFavorite>(
      IsFavorite(Get.find<ProductsRepository>()),
      permanent: true,
    );

    Get.put<AppStateHandlerController>(AppStateHandlerController());
  }
}

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductDetailsController>(
      ProductDetailsController(
        getProductDetails: Get.find<GetProductDetails>(),
        toggleFavorite: Get.find<ToggleFavorite>(),
        isFavorite: Get.find<IsFavorite>(),
      ),
    );
  }
}

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductsController>(
      ProductsController(
        getProducts: Get.find<GetProducts>(),
        getFavorites: Get.find<GetFavorites>(),
      ),
    );
  }
}
