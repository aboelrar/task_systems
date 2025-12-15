import 'package:hive/hive.dart';
import '../../../../core/error/exception.dart';
import '../model/product_model.dart';

abstract class ProductsLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProduct(ProductModel product);
  Future<ProductModel?> getCachedProduct(int id);

  Future<bool> toggleFavorite(int productId);
  Future<List<int>> getFavorites();
  Future<bool> isFavorite(int productId);
}

class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  final Box productsBox;
  final Box favoritesBox;

  ProductsLocalDataSourceImpl({
    required this.productsBox,
    required this.favoritesBox,
  });

  static const _productsKey = 'cached_products';
  static String _productKey(int id) => 'product_$id';
  static const _favoritesKey = 'favorites_ids';

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await productsBox.put(_productsKey, ProductModel.listToJson(products));
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final raw = productsBox.get(_productsKey);
    if (raw == null) throw CacheException();
    final list = (raw as List).cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    return list.map(ProductModel.fromJson).toList();
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    await productsBox.put(_productKey(product.id), product.toJson());
  }

  @override
  Future<ProductModel?> getCachedProduct(int id) async {
    final raw = productsBox.get(_productKey(id));
    if (raw == null) return null;
    return ProductModel.fromJson(Map<String, dynamic>.from(raw as Map));
  }

  @override
  Future<bool> toggleFavorite(int productId) async {
    final ids = await getFavorites();
    final set = ids.toSet();
    if (set.contains(productId)) {
      set.remove(productId);
      await favoritesBox.put(_favoritesKey, set.toList());
      return false;
    } else {
      set.add(productId);
      await favoritesBox.put(_favoritesKey, set.toList());
      return true;
    }
  }

  @override
  Future<List<int>> getFavorites() async {
    final raw = favoritesBox.get(_favoritesKey);
    if (raw == null) return <int>[];
    return (raw as List).map((e) => (e as num).toInt()).toList();
  }

  @override
  Future<bool> isFavorite(int productId) async {
    final ids = await getFavorites();
    return ids.contains(productId);
  }
}