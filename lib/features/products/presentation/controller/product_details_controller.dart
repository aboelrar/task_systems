import 'package:get/get.dart';
import 'package:systems_task/core/controllers/main_controller.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/widgets/app_state_handler/app_state.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecase/get_product_details.dart';
import '../../domain/usecase/is_favorite.dart';
import '../../domain/usecase/toggle_favorite.dart';

class ProductDetailsController extends MainController {
  final GetProductDetails getProductDetails;
  final ToggleFavorite toggleFavorite;
  final IsFavorite isFavorite;

  final int productId = Get.arguments as int;

  ProductDetailsController({
    required this.getProductDetails,
    required this.toggleFavorite,
    required this.isFavorite,
  });

  final errorMessage = RxnString();
  final product = Rxn<Product>();
  final isFav = false.obs;

  Future<void> load() async {
    errorMessage.value = null;
    showLoading();

    final favRes = await isFavorite(IdParams(productId));
    favRes.fold((_) {}, (r) => isFav.value = r);

    final res = await getProductDetails(IdParams(productId));
    res.fold(
      (l) {
        errorMessage.value = l.message;
      },
      (r) {
        product.value = r;
      },
    );
    hideLoading();
  }

  Future<void> onToggleFavorite() async {
    errorMessage.value = null;

    final p = product.value;
    if (p == null) return;

    final res = await toggleFavorite(IdParams(p.id));
    res.fold((l) => errorMessage.value = l.message, (r) => isFav.value = r);
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }
}
