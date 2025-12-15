import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:systems_task/app/routes/app_routes.dart';
import 'package:systems_task/features/products/presentation/ui/product_details_page.dart';

import '../bindings/app_binding.dart';
import '../../features/products/presentation/ui/products_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.products,
      page: () => const ProductsPage(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () =>  ProductDetailsPage(),
      binding: ProductDetailsBinding(),
    ),

    // Add more pages here
  ];
}
