import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:systems_task/core/widgets/custon_scaffold/custom_scaffold.dart';

import '../../../../core/style/app_styles.dart';
import '../controller/product_details_controller.dart';

class ProductDetailsPage extends GetView<ProductDetailsController> {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomScaffold(
        errorMessage: controller.errorMessage.value,
        title: 'Details',
        body: _body(),
        isLoading: controller.isLoading,
      );
    });
  }

  Widget _body() {
    final product = controller.product.value;
    if (product == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(product.title, style: AppStyles.titleStyle),
          const SizedBox(height: 8),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: AppStyles.mediumTextStyle,
          ),
          const SizedBox(height: 12),
          Text(product.description),
          const SizedBox(height: 20),
          Obx(() {
            return FilledButton.icon(
              onPressed: controller.onToggleFavorite,
              icon: Icon(
                controller.isFav.value ? Icons.favorite : Icons.favorite_border,
              ),
              label: Text(
                controller.isFav.value
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
              ),
            );
          }),
        ],
      ),
    );
  }
}
