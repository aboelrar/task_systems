import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:systems_task/app/routes/app_routes.dart';
import 'package:systems_task/features/products/presentation/ui/product_card.dart';
import '../../../../core/widgets/custon_scaffold/custom_scaffold.dart';
import '../controller/products_controller.dart';

class ProductsPage extends GetView<ProductsController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomScaffold(
        isLoading: controller.isLoading,
        errorMessage: controller.error.value,
        title: 'Products',
        body: RefreshIndicator(
          onRefresh: controller.refresh,
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, i) {
                    final p = controller.products[i];
                    final fav = controller.favoriteIds.contains(p.id);

                    return ProductCard(
                      product: p,
                      isFavorite: fav,
                      onTap: () async {
                        await Get.toNamed(
                          AppRoutes.productDetails,
                          arguments: p.id,
                        );
                        controller.load();
                      },
                    );
                  },
                ),
              ),
              if (controller.isLoadingMore.value)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      );
    });
  }
}
