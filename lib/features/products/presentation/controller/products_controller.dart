import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:systems_task/core/controllers/main_controller.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecase/get_favorites.dart';
import '../../domain/usecase/get_products.dart';

class ProductsController extends MainController {
  final GetProducts getProducts;
  final GetFavorites getFavorites;

  ProductsController({required this.getProducts, required this.getFavorites});

  final products = <Product>[].obs;
  final favoriteIds = <int>{}.obs;

  final isRefreshing = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final error = RxnString();

  final scrollController = ScrollController();

  final int _pageSize = 10;
  int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    load();

    scrollController.addListener(() {
      final pos = scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 300) {
        loadMore();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      isRefreshing.value = true;
    } else {
      showLoading();
    }

    error.value = null;
    hasMore.value = true;
    _limit = _pageSize;

    try {
      final favRes = await getFavorites(NoParams());
      favRes.fold(
            (l) => error.value = l.message,
            (r) => favoriteIds.value = r.toSet(),
      );

      final res = await getProducts(GetProductsParams(_limit));
      res.fold(
            (l) {
          error.value = l.message;
          products.clear();
          hasMore.value = false;
        },
            (r) {
          products.assignAll(r);
          hasMore.value = r.length == _limit;
        },
      );
    } finally {
      if (refresh) {
        isRefreshing.value = false;
      } else {
        hideLoading();
      }
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;

    isLoadingMore.value = true;

    try {
      final nextLimit = _limit + _pageSize;
      final res = await getProducts(GetProductsParams(nextLimit));

      res.fold(
            (l) => error.value = l.message,
            (r) {
          final existingIds = products.map((e) => e.id).toSet();
          final newItems =
          r.where((e) => !existingIds.contains(e.id)).toList();

          products.addAll(newItems);
          _limit = nextLimit;

          if (newItems.isEmpty) hasMore.value = false;
        },
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refresh() => load(refresh: true);
}